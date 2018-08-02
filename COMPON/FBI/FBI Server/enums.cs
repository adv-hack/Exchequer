namespace IRIS.Systems.InternetFiling
{
    public enum DocumentStatus
    {
        NOSTATUS = 0,
        SUBMITTING,
        UNKNOWN,
        POLLING,
        DELETING,
        ACCEPTED,
        REJECTED,
        TIMEDOUT,
        TESTCASE
    }

    public enum ApplicationCommands
    {
        STOP,
        PAUSE
    }

}
