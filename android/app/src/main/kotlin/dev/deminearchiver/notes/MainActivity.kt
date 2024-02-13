package dev.deminearchiver.notes

import android.content.Context
import android.media.RingtoneManager
import android.net.Uri
import android.provider.Settings
import android.webkit.MimeTypeMap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Future

class MainActivity: FlutterActivity() {
  private val codec = "dev.deminearchiver.notes/native"

  private val alarms = arrayListOf<HashMap<String, Any>>()

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    loadAlarms(context)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, codec).setMethodCallHandler{
      call, result ->
      when (call.method) {
          "getAllAlarms" -> {
            result.success(alarms)
          }
          "playDefaultAlarm" -> {
            val ringtone = RingtoneManager.getRingtone(context, Settings.System.DEFAULT_ALARM_ALERT_URI)
            ringtone.play()

            val uriType = context.contentResolver.getType(Uri.EMPTY)
            MimeTypeMap.getSingleton().getExtensionFromMimeType(uriType)


            result.success(null)
          }
          else -> {
            result.notImplemented()
          }
      }
    }
  }
  //  https://github.com/imedboumalek/flutter_system_ringtones/blob/main/android/src/main/kotlin/com/pavlok/flutter_system_ringtones/FlutterSystemRingtonesPlugin.kt
  private fun loadAlarms(context: Context) {
    val manager = RingtoneManager(context)
    manager.setType(RingtoneManager.TYPE_ALARM)
    val cursor = manager.cursor
    if(!cursor.isFirst) cursor.moveToFirst()
    do {
      val itemTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
      val itemId = cursor.getString(RingtoneManager.ID_COLUMN_INDEX)
//      val itemUri =
//        cursor.getString(RingtoneManager.URI_COLUMN_INDEX) + "/" + itemId
      val itemUri =
        cursor.getString(RingtoneManager.URI_COLUMN_INDEX)
      val temp = hashMapOf<String, Any>(
        "id" to itemId,
        "title" to itemTitle,
        "uri" to itemUri,
      )
      alarms.add(temp)
    } while (cursor.moveToNext())
    cursor.close()
  }
}
