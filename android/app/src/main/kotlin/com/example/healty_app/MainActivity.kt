package com.example.healty_app

import android.content.Intent
import android.provider.CalendarContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "healthy_app/calendar")
            .setMethodCallHandler { call, result ->
                if (call.method != "createEvent") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val arguments = call.arguments as? Map<*, *>
                val title = arguments?.get("title") as? String
                val description = arguments?.get("description") as? String
                val location = arguments?.get("location") as? String
                val startMillis = arguments?.get("startMillis") as? Number
                val endMillis = arguments?.get("endMillis") as? Number
                if (title == null || startMillis == null || endMillis == null) {
                    result.error("invalid_event", "Missing calendar event fields", null)
                    return@setMethodCallHandler
                }

                val intent = Intent(Intent.ACTION_INSERT).apply {
                    data = CalendarContract.Events.CONTENT_URI
                    putExtra(CalendarContract.Events.TITLE, title)
                    putExtra(CalendarContract.Events.DESCRIPTION, description)
                    putExtra(CalendarContract.Events.EVENT_LOCATION, location)
                    putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startMillis.toLong())
                    putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endMillis.toLong())
                }
                try {
                    if (intent.resolveActivity(packageManager) == null) {
                        result.success("unavailable")
                    } else {
                        startActivity(Intent.createChooser(intent, "إضافة إلى التقويم"))
                        result.success("opened")
                    }
                } catch (error: Exception) {
                    result.error("calendar_unavailable", error.message, null)
                }
            }
    }
}
