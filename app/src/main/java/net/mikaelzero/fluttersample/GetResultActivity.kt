package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec


/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:20 PM
 * @Description:
 */
class GetResultActivity : AppCompatActivity() {
    lateinit var flutterEngine: FlutterEngine
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_home)

        flutterEngine = FlutterEngine(this)
        flutterEngine.navigationChannel.setInitialRoute("sendMsgToAndroid")
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)


        val cachedEngineIntentBuilder = FlutterActivity.CachedEngineIntentBuilder(FlutterActivity::class.java, "my_engine_id")

        findViewById<TextView>(R.id.tv).text = "this is android page \n this page will get flutter receive \ngo to flutter page"
        findViewById<TextView>(R.id.tv).setOnClickListener {
            startActivity(
                cachedEngineIntentBuilder.build(this)
            )
        }
        addListener()

    }

    private fun addListener() {
        val mBasicMessageChannel = BasicMessageChannel(flutterEngine.dartExecutor, "messageChannelForFlutterToAndroid", StandardMessageCodec.INSTANCE)
        mBasicMessageChannel.setMessageHandler { message, reply ->
            findViewById<TextView>(R.id.tv).text = "receive flutter message is :\n${message.toString()}\n"
        }
    }


}