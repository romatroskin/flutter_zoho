package co.foreman.app.flutter_zoho;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;

import com.zoho.desk.asap.ZDPHomeConfiguration;
import com.zoho.desk.asap.ZDPortalHome;
import com.zoho.desk.asap.api.ZDPortalCallback;
import com.zoho.desk.asap.api.ZDPortalException;
import com.zoho.desk.asap.api.ZohoDeskPortalSDK;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterZohoPlugin
 */
public class FlutterZohoPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    public static ZohoDeskPortalSDK deskInstance;

    Activity activity;
    Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoho");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        if (call.method.equals("initZoho")) {
            String fcm = call.argument("fcmId");
            String orgId = call.argument("orgId");
            String appId = call.argument("appId");

            ZohoDeskPortalSDK.Logger.enableLogs();

            deskInstance = ZohoDeskPortalSDK.getInstance(context.getApplicationContext());
            deskInstance.initDesk(Long.parseLong(orgId), appId, ZohoDeskPortalSDK.DataCenter.EU);
            deskInstance.enablePush(fcm);
            // deskInstance.setThemeResource(R.style.deskTheme);
        }

        if (call.method.equals("showNativeView")) {
            String accessToken = call.argument("accessToken");

            final ZDPHomeConfiguration homeConfiguration = new ZDPHomeConfiguration.Builder()
            .showCommunity(true)
            .showCreateTicket(true)
            .showNavDrawer(true)
            .showMyTickets(true)
            .build();

            deskInstance = ZohoDeskPortalSDK.getInstance(context.getApplicationContext());
            if (!deskInstance.isUserSignedIn()) {
                deskInstance.setUserToken(accessToken, new ZDPortalCallback.SetUserCallback() {
                    @Override
                    public void onUserSetSuccess() {
                        ZDPortalHome.show(activity, homeConfiguration);
                        result.success("true");
                    }

                    @Override
                    public void onException(ZDPortalException e) {
                        // result.error("400", e.getMessage(), "false");
                    }
                });
            } else {
                ZDPortalHome.show(activity, homeConfiguration);
                result.success("true");
            }
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull @org.jetbrains.annotations.NotNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull @org.jetbrains.annotations.NotNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}