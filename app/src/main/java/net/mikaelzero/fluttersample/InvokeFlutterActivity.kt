package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodChannel

/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:20 PM
 * @Description:
 */
class InvokeFlutterActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_home)

        findViewById<TextView>(R.id.tv).text = "this is android page \n click invoke flutter method"
        findViewById<TextView>(R.id.tv).setOnClickListener {
            val methodChannel = MethodChannel(MainActivity.flutterEngine.dartExecutor, "invokeFlutterMethodName")
            methodChannel.invokeMethod("getName", null, object : MethodChannel.Result {
                override fun notImplemented() {

                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {

                }

                override fun success(result: Any?) {
                    findViewById<TextView>(R.id.tv).text = "get flutter method result:" + result.toString()
                }
            })
        }
    }
}