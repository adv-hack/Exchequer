unit WM_Const;

interface

// Constants for WParam values used by message-handlers
const
  // ---------------------------------------------------------------------------
  // Existing WParam values (which cannot be changed without making multiple
  // changes across the system)
  // ---------------------------------------------------------------------------

  // 1. Values used with WM_FormCloseMsg

  // WP_START_TREE_MOVE - called before moving an item in the Job Tree or GL Tree
  WP_START_TREE_MOVE = 70;

  // WP_END_TREE_MOVE - called after moving an item in the Job Tree or GL Tree
  WP_END_TREE_MOVE = 72;

  // ---------------------------------------------------------------------------
  // New WParam values
  // ---------------------------------------------------------------------------
  // Base for new WParam values, outside the known range of existing values
  WP_BASE = 10000;

  // 1. Values used with WM_FormCloseMsg

  // WP_CLOSE_JOB_TOTALS_FORM - sent from the Job Totals form to the Job Tree form
  // when the Job Totals form is closed
  WP_CLOSE_JOB_TOTALS_FORM = WP_BASE + 1;

  // WP_CLOSE_ICC_FORM - Sent from the Intrastat Control Centre form to the
  // main Exchequer form when the ICC form is closed
  WP_CLOSE_ICC_FORM = WP_BASE + 2;

implementation

end.
