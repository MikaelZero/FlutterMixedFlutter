package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

/**
 * @Author:         MikaelZero
 * @CreateDate:     2020/10/20 3:14 PM
 * @Description:
 */
class OpenWebViewActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_open_web_view)
        val tv = findViewById<TextView>(R.id.tv)
        tv.setOnClickListener {

        }

    }
}