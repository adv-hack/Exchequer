using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Security;
using System.Security.Policy;

namespace CASPolicy_CS
{
    public class SecurityFunctions
    {
        public static int AddUrlSecurityGroup(string GroupName, string Url, string TrustLevel)
        {
            SecurityFunctions secFuncs = new SecurityFunctions();

            PolicyLevel machineLevel = secFuncs.GetPolicyLevel(PolicyLevelType.Machine);

            string[] groupPath = GroupName.Split(new string[] { "\\" }, StringSplitOptions.None);

            int startIndex = 0;
            if (groupPath[0].Length == 0)
            {
                startIndex = 1;
            }

            CodeGroup parentGroup = secFuncs.GetDescendantCodeGroup(machineLevel.RootCodeGroup, groupPath, startIndex, groupPath.Length - startIndex);

            if (parentGroup == null)
            {
                return (int)ReturnCodes.Security_NoSuchGroup;
            }

            try
            {
                secFuncs.RemoveGroupIfExists(parentGroup, Url);
                SecurityManager.SavePolicy();
            }
            catch
            {
            }


            secFuncs.AddUrlCodeGroup(parentGroup, groupPath[groupPath.Length-1], Url, TrustLevel); 

            SecurityManager.SavePolicy();
            return (int)ReturnCodes.Success;
        }

        private PolicyLevel GetPolicyLevel(PolicyLevelType type)
        {
            IEnumerator enumerator = SecurityManager.PolicyHierarchy();

            while (enumerator.MoveNext())
            {
                PolicyLevel level = (PolicyLevel)enumerator.Current;
                if (level.Type == type)
                    return level;
            }

            return null;
        }

        private CodeGroup GetDescendantCodeGroup(CodeGroup parentGroup, string path)
        {
            string[] pathComponents = path.Split(new string[] { "\\" }, StringSplitOptions.RemoveEmptyEntries);
            return GetDescendantCodeGroup(parentGroup, pathComponents);
        }

        private CodeGroup GetDescendantCodeGroup(CodeGroup parentGroup, string[] pathComponents)
        {
            return GetDescendantCodeGroup(parentGroup, pathComponents, 0, pathComponents.Length);
        }
    
        private CodeGroup GetDescendantCodeGroup(CodeGroup parentGroup, string[] pathComponents, int startIndex, int count)
        {
            CodeGroup group = parentGroup;
            for (int i = startIndex; i < count; i++)
            {
                group = GetChildGroup(parentGroup, pathComponents[i]);
                if (group == null)
                    return null;
            }
            return group;
        }

        private CodeGroup GetChildGroup(CodeGroup parentGroup, String name)
        {
            for(int i = 0; i < parentGroup.Children.Count; i++)
            {
                CodeGroup group = (CodeGroup)parentGroup.Children[i];
                if (String.Equals(group.Name, name))
                {
                    return group;
                }
            }
            return null;
        }

        public void RemoveGroupIfExists(CodeGroup parentGroup, String name)
        {
            CodeGroup childGroup; 
            while( (childGroup = GetChildGroup(parentGroup, name)) != null)
                parentGroup.RemoveChild(childGroup);
        }

        private void AddUrlCodeGroup(CodeGroup parentGroup, String groupName, String url, String permissionSetName)
        {
            RemoveGroupIfExists(parentGroup, groupName);

            PermissionSet permSet = new NamedPermissionSet(permissionSetName);
            IMembershipCondition membershipCondition = new UrlMembershipCondition(url);
            PolicyStatement statement = new PolicyStatement(permSet);
            CodeGroup group = new UnionCodeGroup(membershipCondition, statement);

            group.Name = groupName;

            parentGroup.AddChild(group);
        }
    }

    public enum ReturnCodes
    {
        Success = 0,
        UnhandledException = -1,
        Security_NoSuchGroup = -2
    }
}
