# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep your application classes that will be used by Flutter
-keep class com.example.baleen_mobile.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelables
-keep class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep Serializable classes
-keepnames class * implements java.io.Serializable

# Keep R8 full mode
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Prevent name obfuscation of classes referenced in the AndroidManifest.xml
-keepnames class * extends android.app.Activity
-keepnames class * extends android.app.Service
-keepnames class * extends android.content.BroadcastReceiver
-keepnames class * extends android.content.ContentProvider
-keepnames class * extends android.app.backup.BackupAgentHelper
-keepnames class * extends android.preference.Preference
-keepnames class * extends android.view.View
-keepnames class * extends android.app.Application
-keepnames class * extends android.appwidget.AppWidgetProvider
-keepnames class * extends android.app.admin.DeviceAdminReceiver
-keepnames class * extends android.database.sqlite.SQLiteOpenHelper
-keepnames class * extends android.os.FileObserver
-keepnames class * extends android.app.backup.BackupAgent
-keepnames class * extends android.appwidget.AppWidgetHost
-keepnames class * extends android.database.ContentObserver
-keepnames class * extends android.app.backup.BackupHelper
-keepnames class * extends android.app.backup.FileBackupHelper
-keepnames class * extends android.app.backup.SharedPreferencesBackupHelper 