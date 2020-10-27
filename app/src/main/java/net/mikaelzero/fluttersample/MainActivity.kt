package net.mikaelzero.fluttersample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry


class MainActivity : AppCompatActivity() {
    companion object {
        lateinit var flutterEngine: FlutterEngine
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val tv = findViewById<TextView>(R.id.tv)

        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)

        val cachedEngineIntentBuilder = FlutterActivity.CachedEngineIntentBuilder(FlutterActivity::class.java, "my_engine_id")
        flutterEngine.plugins.add(FlutterPluginBatterylevelPlugin())
        tv.setOnClickListener {
            startActivity(
                cachedEngineIntentBuilder.build(this)
            )
        }
    }
}