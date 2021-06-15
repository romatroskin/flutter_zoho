package co.foreman.app.flutter_zoho;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;

import com.zoho.deskportalsdk.DeskConfig;
import com.zoho.deskportalsdk.ZohoDeskPortalSDK;
import com.zoho.deskportalsdk.android.network.DeskCallback;

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
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  public static ZohoDeskPortalSDK deskInstance;

  Activity activity;
  Context context;

  long OrgId;
  String AppId;
  String accessToken;
//    public String ZOHO_CHANNEL = "com.zoho.deskportalsdk";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoho");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    // if (call.method.equals("getPlatformVersion")) {
    //     result.success("Android " + android.os.Build.VERSION.RELEASE);
    // }

    if (call.method.equals("setFCMId")) {
      String fcm = call.argument("fcmId");
      deskInstance.enablePush(fcm);
    }

    if (call.method.equals("showNativeView")) {

      HashMap<String, Object> map = call.arguments();

      try {
        JSONObject params = new JSONObject(map);
        OrgId = Long.parseLong(params.getString("orgId"));
        AppId = params.getString("appId");
        accessToken = params.getString("accessToken");

      } catch (JSONException e) {
        e.printStackTrace();

        return;
      }

      ZohoDeskPortalSDK.Logger.enableLogs();

      DeskConfig config = new DeskConfig.Builder()
              .showCommunity(true)
              .showCreateTicket(true)
              .showNavDrawer(true)
              .showMyTickets(true)
              .build();
      deskInstance = ZohoDeskPortalSDK.getInstance((Application) context.getApplicationContext());
      deskInstance.initDesk(OrgId, AppId, ZohoDeskPortalSDK.DataCenter.EU, config);
//                deskInstance.setThemeResource(R.style.deskTheme);
      // if(deskInstance.isUserSignedIn()){
      deskInstance.setUserToken(accessToken, new DeskCallback.DeskSetUserCallback() {
        @Override
        public void onUserSetSuccess() {

          deskInstance.startDeskHomeScreen(activity);
          result.success("true");
        }

        @Override
        public void onException(DeskException e) {

          result.error("400", e.getMessage(), "false");
        }
      });
    } else {
      result.notImplemented();
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

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull @org.jetbrains.annotations.NotNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}