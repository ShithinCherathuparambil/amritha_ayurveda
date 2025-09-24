/// Utility class for date and time operations
class DateUtils {
  DateUtils._();

  /// Format date to readable string
  static String formatDate(DateTime date, {DateFormat format = DateFormat.medium}) {
    switch (format) {
      case DateFormat.short:
        return '${date.day}/${date.month}/${date.year}';
      case DateFormat.medium:
        return '${date.day} ${_getMonthName(date.month)} ${date.year}';
      case DateFormat.long:
        return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
      case DateFormat.full:
        return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year} at ${formatTime(date)}';
    }
  }

  /// Format time to readable string
  static String formatTime(DateTime dateTime, {bool use24Hour = false}) {
    if (use24Hour) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = dateTime.hour;
      final minute = dateTime.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    }
  }

  /// Format date and time to readable string
  static String formatDateTime(DateTime dateTime, {bool use24Hour = false}) {
    return '${formatDate(dateTime)} at ${formatTime(dateTime, use24Hour: use24Hour)}';
  }

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      // Future date
      final futureDifference = dateTime.difference(now);
      if (futureDifference.inDays > 0) {
        return 'in ${futureDifference.inDays} day${futureDifference.inDays == 1 ? '' : 's'}';
      } else if (futureDifference.inHours > 0) {
        return 'in ${futureDifference.inHours} hour${futureDifference.inHours == 1 ? '' : 's'}';
      } else if (futureDifference.inMinutes > 0) {
        return 'in ${futureDifference.inMinutes} minute${futureDifference.inMinutes == 1 ? '' : 's'}';
      } else {
        return 'in a few seconds';
      }
    } else {
      // Past date
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Get days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  /// Check if year is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  /// Get days in month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Parse date string safely
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get month name
  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  /// Get day name
  static String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  /// Get short month name
  static String getShortMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Get short day name
  static String getShortDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  /// Format duration to readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

/// Date format enumeration
enum DateFormat {
  short,   // 1/1/2024
  medium,  // 1 Jan 2024
  long,    // Monday, 1 January 2024
  full,    // Monday, 1 January 2024 at 10:30 AM
}
