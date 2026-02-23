############################################################
# Flutter Core
############################################################

# Keep Flutter engine
-keep class io.flutter.** { *; }

# Keep GeneratedPluginRegistrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep all Flutter plugins
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

# Prevent MissingPluginException
-keepclassmembers class * {
    public void onMethodCall(io.flutter.plugin.common.MethodCall, io.flutter.plugin.common.MethodChannel$Result);
}

############################################################
# Firebase (Safe + Minimal)
############################################################

# Firebase Core
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Firebase Messaging
-keep class * extends com.google.firebase.messaging.FirebaseMessagingService { *; }

############################################################
# Android Components (Manifest Safety)
############################################################

-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider

############################################################
# Parcelable
############################################################

-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

############################################################
# Keep Enums
############################################################

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

############################################################
# Keep Annotations & Generics (Important)
############################################################

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes SourceFile
-keepattributes LineNumberTable

############################################################
# Remove Logs in Release
############################################################

-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

############################################################
# Suppress Harmless Warnings
############################################################

-dontwarn kotlin.**
-dontwarn kotlinx.**
-dontwarn org.jetbrains.**
-dontwarn javax.annotation.**
