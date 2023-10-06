package com.example.callkit_experimental

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "callkit.flutter.dev"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // MARK : - Set Up [MESSAGE_CHANNEL] Handler
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "$CHANNEL/message").setMethodCallHandler {
      call, result ->
        if (call.method == "getMessage") {
            result.success("Get Message From Android Native Core")
        }
    }

    // MARK : - Set Up [NETWORK_CHANNEL] Handler


      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "$CHANNEL/network").setMethodCallHandler {
          call, result ->

          if (call.method == "getNetworkStatus") {
                result.success(true)
          }

      }

    // MARK : - Set Up [COMPUTE_CHANNEL] Handler

      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "$CHANNEL/compute").setMethodCallHandler {
          call, result ->
          val operands : Array<String>  = arrayOf("+","-","*","/")

          val args = call.arguments as HashMap<String,*>
          val x = args["x"] as Double
          val y = args["y"] as Double
          val operand = args["operand"]

          if(operands.contains(operand)) {
              if (call.method == "getCompute") {
                  var answer : Double  = 0.0;
                 when (operand) {
                     "+" -> answer = x + y
                     "-" -> answer = x - y
                     "*" -> answer = x * y
                     "/" -> answer = x / y
                     else -> {
                         result.error("1001" , "Invalid Operand" ,"")
                     }
                 }
                  result.success(answer)
              }
          } else {
              result.error("1001","Invalid Operand","")
          }
      }
  }
}