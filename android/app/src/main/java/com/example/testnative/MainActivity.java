
package com.example.testnative;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "it.pixeldump.pocs.fluttermakesomenoise";

    private ToneGenerator tn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        tn = new ToneGenerator();

        initMethodChannelHandlers();
    }

    private void initMethodChannelHandlers() {

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("setWaveform")) {
                            String waveform = (String) call.argument("waveform");
                            tn.setWaveform(waveform);
                        } else if (call.method.equals("setFrequency")) {
                            double frequency = (double) call.argument("frequency");
                            tn.setFrequency(frequency);
                        } else if (call.method.equals("play")) {
                            if (!tn.playing()) {
                                tn.startPlayback();
                            }
                        } else if (call.method.equals("stop")) {
                            tn.stopIfPlaying();
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }
}
