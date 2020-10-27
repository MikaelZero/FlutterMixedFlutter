package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec


/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:20 PM
 * @Description:
 */
class SendMessageActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_home)
        findViewById<TextView>(R.id.tv).text = "this is android page \n click to finish this page and send msg to flutter"
        findViewById<TextView>(R.id.tv).setOnClickListener {
            addBasicMessageChannel()
            finish()
        }
    }

    private fun addBasicMessageChannel() {
        val mBasicMessageChannel = BasicMessageChannel(MainActivity.flutterEngine.dartExecutor, "messageChannelForAndroidToFlutter", StandardMessageCodec.INSTANCE)
        mBasicMessageChannel.send("native say hello to flutter") {
        }
    }


}