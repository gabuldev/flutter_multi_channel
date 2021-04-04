package com.example.multi_channel;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.UiThread;

import com.squareup.okhttp.Callback;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;
import com.squareup.okhttp.ResponseBody;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;

import app.loup.streams_channel.StreamsChannel;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;


/** MultiChannelPlugin */
public class MultiChannelPlugin implements FlutterPlugin{
    final StreamHandler streamHandler = new StreamHandler();

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        final StreamsChannel channel = new StreamsChannel(binding.getBinaryMessenger(), "multi_channel");
        channel.setStreamHandlerFactory(arguments -> streamHandler);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {

    }


    public static class StreamHandler implements EventChannel.StreamHandler {

        private final Handler handler = new Handler(Looper.getMainLooper());
        HashMap<String,Object>  apiRequest;

        private final Runnable runnable = new Runnable() {
            @Override
            public void run() {
                String url = (String) apiRequest.get("path");
                String method = (String) apiRequest.get("method");

                OkHttpClient httpClient = new OkHttpClient();
                Request request = new Request.Builder().url(url).build();
               httpClient.newCall(request).enqueue(new Callback() {
                    @Override
                    public void onFailure(Request request, IOException e) {
                       handler.post(new Runnable() {
                           @Override
                           public void run() {
                               eventSink.success(request);
                               eventSink.endOfStream();
                           }
                       });
                    }

                    @Override
                    public void onResponse(Response response) throws IOException {
                        handler.post(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String,Object> data = new HashMap<String, Object>();
                                data.put("id",apiRequest.get("id"));
                                try {
                                    data.put("body",response.body().string().toString());
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }

                                eventSink.success(data);
                                eventSink.endOfStream();
                            }
                        });

                    }
                });

            }
        };

        private EventChannel.EventSink eventSink;
        private int count = 1;

        @Override
        public void onListen(Object o, final EventChannel.EventSink eventSink) {

            apiRequest = (HashMap<String, Object>) o;
            this.eventSink = eventSink;
            runnable.run();
        }

        @Override
        public void onCancel(Object o) {

            System.out.println("StreamHandler - onCancel: " + o);
            handler.removeCallbacks(runnable);
        }
    }
}