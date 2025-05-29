class DataUtils {
  /// Private constructor to hide the constructor.
  DataUtils._();

  ///Used to check if the [value] is [Null] or Empty(""," ") [String],
  ///or if it is [Null] or Equivalent Zero(0) [int] or [double] Number,
  ///or if it is [Null] or Empty [List], [Set] or [Map].
  static bool _isNullOrEmpty(dynamic value) {
    if (value == null) {
      return true;
    } else if (value is String) {
      return value.trim().isEmpty || value == 'null';
    } else if (value is num) {
      return value == 0;
    } else if (value is Iterable) {
      return value.isEmpty;
    } else if (value is Map) {
      return value.isEmpty;
    } else {
      return false;
    }
  }

  ///Used to check if the [value] is [Null] or Empty(""," ") [String]
  static bool isNullOrEmptyString(String? value) => _isNullOrEmpty(value);

  ///Used to check if the [value] is [Null] or Equivalent Zero(0) [int] or [double] Number
  static bool isNullOrZeroNumber(num? value) => _isNullOrEmpty(value);

  ///Used to check if the [value] is [Null] or Empty [List] or [Set]
  static bool isNullOrEmptyIterable(Iterable<dynamic>? value) => _isNullOrEmpty(value);

  ///Used to check if the [value] is [Null] or Empty [Map]
  static bool isNullOrEmptyMap(Map<dynamic, dynamic>? value) => _isNullOrEmpty(value);

  static bool isEmail(String email) {
    final RegExp regExp = RegExp(r'\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*');
    return regExp.hasMatch(email);
  }
}

/*extension DataUtilsExtension on dynamic {
  bool get isNullOrEmpty => DataUtils.isNullOrEmpty(this);
  bool get isNotNullOrEmpty => !DataUtils.isNullOrEmpty(this);
}*/

extension DataUtilsStringExtension on String? {
  ///Returns true if the value is [Null] or Empty(""," ") [String]
  ///& false if the value is not [Null] or Empty(""," ") [String]
  bool get isNullOrEmpty => DataUtils.isNullOrEmptyString(this);

  ///Returns true if the value is not [Null] or Empty(""," ") [String]
  ///& false if the value is [Null] or Empty(""," ") [String]
  bool get isNotNullOrEmpty => !DataUtils.isNullOrEmptyString(this);
}

extension DataUtilsNumberExtension on num? {
  ///Returns true if the value is [Null] or Equivalent Zero(0) [int] or [double] Number
  ///& false if the value is not [Null] or Equivalent Zero(0) [int] or [double] Number
  bool get isNullOrZero => DataUtils.isNullOrZeroNumber(this);

  ///Returns true if the value is not [Null] or Equivalent Zero(0) [int] or [double] Number
  ///& false if the value is [Null] or Equivalent Zero(0) [int] or [double] Number
  bool get isNotNullOrZero => !DataUtils.isNullOrZeroNumber(this);
}

extension DataUtilsIterableExtension on Iterable<dynamic>? {
  ///Returns true if the value is [Null] or Empty [List] or [Set]
  ///& false if the value is not [Null] or Empty [List] or [Set]
  bool get isNullOrEmpty => DataUtils.isNullOrEmptyIterable(this);

  ///Returns true if the value is not [Null] or Empty [List] or [Set]
  ///& false if the value is [Null] or Empty [List] or [Set]
  bool get isNotNullOrEmpty => !DataUtils.isNullOrEmptyIterable(this);
}

extension DataUtilsMapExtension on Map<dynamic, dynamic>? {
  ///Returns true if the value is [Null] or Empty [Map]
  ///& false if the value is not [Null] or Empty [Map]
  bool get isNullOrEmpty => DataUtils.isNullOrEmptyMap(this);

  ///Returns true if the value is not [Null] or Empty [Map]
  ///& false if the value is [Null] or Empty [Map]
  bool get isNotNullOrEmpty => !DataUtils.isNullOrEmptyMap(this);
}
