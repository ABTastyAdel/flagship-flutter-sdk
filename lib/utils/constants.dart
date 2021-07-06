import '../flagship_version.dart';

enum Mode {
  DECISION_API,
  BUCKETING,
}

/// START
const String STARTED = "Flagship SDK (version: $FlagshipVersion) is started";
const String INITIALIZATION_PARAM_ERROR = "Params 'envId' is not valide.";

// ToDo: update this wording when the sdk manage other type

// CONTEXT
const String CONTEXT_UPDATE = "Update context with Map %s";
const String CONTEXT_PARAM_ERROR =
    "params 'key' must be a non null String, and 'value' must be one of the " +
        "following types : String, Number, Boolean.";
const String PARSING_ERROR = "an error occured whil parsing ";

// MODIFICATION
const String SYNCHRONIZE_MODIFICATIONS =
    "Flagship SDK - synchronize modifications.";
const String SYNCHRONIZE_MODIFICATIONS_RESULTS =
    "Flagship SDK - synchronized modifications are %s";

const String GET_MODIFICATION_ERROR =
    "An error occured while retreiving modification for key '%s'. Default value is returned.";
const String GET_MODIFICATION_INFO_ERROR = "No modification for key '%s'.";

// HITS
const String HIT_SUCCESS = "Flagship hit sent with success";
const String HIT_FAILED = "Flagship failed to send hit";
const String ACTIVATE_SUCCESS = "Flagship activate sent with success";
const String ACTIVATE_FAILED = "Flagship failed to send activate";
const String HIT_INVALID_DATA_ERROR = "'%s' hit invalid format error. \n %s";

// PANIC
const String PANIC = "Flagship panic mode is on.";
const String PANIC_HIT = "Flagship panic mode is on, no event will be sent";

// REQUEST

const String REQUEST_POST_BODY = "Flagship body of the POST:%s";
// EXCEPTION
const String EXCEPTION = "An exception occurred %s";
