package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:20 PM
 * @Description:
 */
class EventChannelActivity : AppCompatActivity() {
    var listenEvents: EventChannel.EventSink? = null
    lateinit var flutterEngine: FlutterEngine
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_home)

        flutterEngine = FlutterEngine(this)
        flutterEngine.navigationChannel.setInitialRoute("listenAndroid")
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)
        val cachedEngineIntentBuilder = FlutterActivity.CachedEngineIntentBuilder(FlutterActivity::class.java, "my_engine_id")

        findViewById<TextView>(R.id.tv).text = "this is android page \n click will start thread and send message to flutter"
        findViewById<TextView>(R.id.tv).setOnClickListener {
            EventChannel(flutterEngine.dartExecutor, "eventChannelAndroidToFlutter")
                .setStreamHandler(object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        listenEvents = events
                    }

                    override fun onCancel(arguments: Any?) {
                    }
                })
            start()
            startActivity(
                cachedEngineIntentBuilder.build(this)
            )
        }
    }

    var finish = false

    override fun onDestroy() {
        super.onDestroy()
        finish = true
    }

    fun start() {
        MsgThread().start()
    }

    private inner class MsgThread : Thread() {
        override fun run() {
            while (true) {
                if (finish) {
                    interrupt()
                } else {
                    sleep(500)
                    sendMessage()
                }
            }
        }
    }

    fun sendMessage() {
        runOnUiThread {
            listenEvents?.success("msg from android:" + Math.random())
        }
    }
}