part of 'app_pages.dart';

abstract class Routes {
  static const String splash = '/';
  static const String logIn = '/login';
  static const String dashBoard = '/dashboard';

  //---------Forms Module Routing Points
  static const String formsIndex = '/forms_index';
  static const String fillOutForm = '/fill_out_form';
  static const String viewUserForm = '/view_user_form';

  //---------Pilot Log Book Module Routing Points
  static const String pilotLogBookIndex = '/pilot_log_book_index';
  static const String flightLogCreateEdit = '/flight_log_create_edit';
  static const String flightLogDetailsView = '/flight_log_details_view';

  //---------Discrepancy Module Routing Points
  static const String discrepancyIndex = '/discrepancy_index';
  static const String discrepancyDetailsNew = '/discrepancy_details_new';
  static const String discrepancyEditAndCreate = '/discrepancy_edit_and_create';

  //---------MEL Module Routing Points
  static const String melIndex = '/mel_index';
  static const String melAircraftTypes = '/mel_aircraft_types';
  static const String melDetails = '/mel_details';
  static const String melEdit = '/mel_edit';

  //---------Parts Request Module Routing Points
  static const String partsRequestIndex = '/parts_request_index';
  static const String partsRequestDetails = '/parts_request_details';

  //---------Flight Ops & Documents Upload, Edit & View Module Routing Points
  static const String flightOpsAndDocuments = '/flight_ops_and_documents';

  //---------File Upload, Edit & View Module Routing Points
  static const String fileUpload = '/file_upload';
  static const String fileEditNew = '/file_edit_new';
  static const String fileView = '/file_view';

  //---------Flight & Duty Day Logs Module Routing Points
  static const String flightAndDutyTimeLogs = '/flight_and_duty_time_logs';
  static const String multipleUserDutyDay = '/multiple_user_duty_day';
  static const String userTimeCardDetails = '/user_time_card_details';

  //----------Operational Expenses Module Routing Points
  static const String operationalExpenseIndex = '/operational_expenses_index';
  static const String operationalExpenseEdit = '/operational_expenses_edit';
  static const String operationalExpenseDetails = '/operational_expenses_details';

  //---------Risk Assessment Module Routing Points
  static const String riskAssessmentIndex = '/risk_assessment_index';
  static const String raFillOutAndFollowUp = '/ra_fill_out_and_follow_up';
  static const String viewRiskAssessment = '/view_risk_assessment';
  static const String raCreateAndEdit = '/ra_create_and_edit';

  //---------Help Desk Module Routing Points
  static const String helpDeskIndex = '/help_desk_index';
  static const String helpDeskDetails = '/help_desk_details';

  //---------Reports Module Routing Points
  static const String reportsIndex = '/reports_index';
  static const String customReportsIndex = '/custom_reports_index';
  static const String customReportsCreateEdit = '/custom_reports_create_edit';
  static const String reportsShow = '/reports_show';
  static const String reportsCustomShow = '/reports_custom_show';

  //---------Inactive / Unused Modules
  static const String addEmployee = '/add_employee';
  static const String flightProfile = '/flight_profile';

  //---------Work Order Module Routing Points
  static const String workOrderIndex = '/work_order_index';
  static const String workOrderBillingView = '/work_order_billing_view';
  static const String workOrderDiscrepancyDetails = '/work_order_discrepancy_details';
  static const String workOrderCreateAndEdit = '/work_order_create_and_edit';
  static const String workOrderDetails = '/work_order_details';
  static const String workOrderScanner = '/work_order_scanner';

  static const String workOrderJobs = '/work_order_jobs';

  //---------Weight & Balance Module Routing Points
  static const String weightAndBalance = '/weight_and_balance';
  static const String aircraftConfiguration = '/aircraft_configuration';
  static const String weightAndBalanceNew = '/weight_and_balance_new_page';

  static const String weather = '/weather';

  //---------Device Registration Info Module Routing Points
  static const String deviceRegInfo = '/device_reg_info';
}
