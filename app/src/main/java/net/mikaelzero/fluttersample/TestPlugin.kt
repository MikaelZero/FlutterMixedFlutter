package net.mikaelzero.fluttersample

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BasicMessageChannel.MessageHandler
import io.flutter.plugin.common.StandardMessageCodec


public class TestPlugin : FlutterPlugin, MessageHandler<Any> {

    private lateinit var channel: BasicMessageChannel<Any>
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = BasicMessageChannel<Any>(binding.flutterEngine.dartExecutor, "flutter_plugin_batterylevel", StandardMessageCodec.INSTANCE)
        channel.setMessageHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMessageHandler(null)
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {

    }

}
