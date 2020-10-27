package net.mikaelzero.fluttersample

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:20 PM
 * @Description:
 */
class FlutterHomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_home)
        findViewById<TextView>(R.id.tv).setOnClickListener {
            val intent = Intent(this, FlutterHomeActivity::class.java)
            intent.action = Intent.ACTION_RUN
            intent.putExtra("route", "/webViewPage")
            startActivity(intent)
        }
    }
}