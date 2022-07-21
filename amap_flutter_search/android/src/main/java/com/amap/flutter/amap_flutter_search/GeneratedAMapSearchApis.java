// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.amap.flutter.amap_flutter_search;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class GeneratedAMapSearchApis {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class ApiResult {
    private @Nullable Map<String, Object> data;
    public @Nullable Map<String, Object> getData() { return data; }
    public void setData(@Nullable Map<String, Object> setterArg) {
      this.data = setterArg;
    }

    private @Nullable String message;
    public @Nullable String getMessage() { return message; }
    public void setMessage(@Nullable String setterArg) {
      this.message = setterArg;
    }

    private @NonNull Long code;
    public @NonNull Long getCode() { return code; }
    public void setCode(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"code\" is null.");
      }
      this.code = setterArg;
    }

    /** Constructor is private to enforce null safety; use Builder. */
    private ApiResult() {}
    public static final class Builder {
      private @Nullable Map<String, Object> data;
      public @NonNull Builder setData(@Nullable Map<String, Object> setterArg) {
        this.data = setterArg;
        return this;
      }
      private @Nullable String message;
      public @NonNull Builder setMessage(@Nullable String setterArg) {
        this.message = setterArg;
        return this;
      }
      private @Nullable Long code;
      public @NonNull Builder setCode(@NonNull Long setterArg) {
        this.code = setterArg;
        return this;
      }
      public @NonNull ApiResult build() {
        ApiResult pigeonReturn = new ApiResult();
        pigeonReturn.setData(data);
        pigeonReturn.setMessage(message);
        pigeonReturn.setCode(code);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("data", data);
      toMapResult.put("message", message);
      toMapResult.put("code", code);
      return toMapResult;
    }
    static @NonNull ApiResult fromMap(@NonNull Map<String, Object> map) {
      ApiResult pigeonResult = new ApiResult();
      Object data = map.get("data");
      pigeonResult.setData((Map<String, Object>)data);
      Object message = map.get("message");
      pigeonResult.setMessage((String)message);
      Object code = map.get("code");
      pigeonResult.setCode((code == null) ? null : ((code instanceof Integer) ? (Integer)code : (Long)code));
      return pigeonResult;
    }
  }

  public interface Result<T> {
    void success(T result);
    void error(Throwable error);
  }
  private static class SearchHostApiCodec extends StandardMessageCodec {
    public static final SearchHostApiCodec INSTANCE = new SearchHostApiCodec();
    private SearchHostApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return ApiResult.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof ApiResult) {
        stream.write(128);
        writeValue(stream, ((ApiResult) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface SearchHostApi {
    @NonNull String getPlatformVersion();
    void setApiKey(@NonNull String apiKey);
    void updatePrivacyShow(@NonNull Boolean isContains, @NonNull Boolean isShow);
    void updatePrivacyAgree(@NonNull Boolean isAgree);
    void searchPoi(@NonNull Long pageNum, @NonNull Long pageSize, @NonNull String query, @NonNull String ctgr, @NonNull String city, @Nullable Object center, @Nullable Long radiusInMeters, @Nullable Boolean isDistanceSort, @NonNull String extensions, Result<ApiResult> result);

    /** The codec used by SearchHostApi. */
    static MessageCodec<Object> getCodec() {
      return SearchHostApiCodec.INSTANCE;
    }

    /** Sets up an instance of `SearchHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, SearchHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SearchHostApi.getPlatformVersion", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              String output = api.getPlatformVersion();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SearchHostApi.setApiKey", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String apiKeyArg = (String)args.get(0);
              if (apiKeyArg == null) {
                throw new NullPointerException("apiKeyArg unexpectedly null.");
              }
              api.setApiKey(apiKeyArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SearchHostApi.updatePrivacyShow", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Boolean isContainsArg = (Boolean)args.get(0);
              if (isContainsArg == null) {
                throw new NullPointerException("isContainsArg unexpectedly null.");
              }
              Boolean isShowArg = (Boolean)args.get(1);
              if (isShowArg == null) {
                throw new NullPointerException("isShowArg unexpectedly null.");
              }
              api.updatePrivacyShow(isContainsArg, isShowArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SearchHostApi.updatePrivacyAgree", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Boolean isAgreeArg = (Boolean)args.get(0);
              if (isAgreeArg == null) {
                throw new NullPointerException("isAgreeArg unexpectedly null.");
              }
              api.updatePrivacyAgree(isAgreeArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SearchHostApi.searchPoi", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Number pageNumArg = (Number)args.get(0);
              if (pageNumArg == null) {
                throw new NullPointerException("pageNumArg unexpectedly null.");
              }
              Number pageSizeArg = (Number)args.get(1);
              if (pageSizeArg == null) {
                throw new NullPointerException("pageSizeArg unexpectedly null.");
              }
              String queryArg = (String)args.get(2);
              if (queryArg == null) {
                throw new NullPointerException("queryArg unexpectedly null.");
              }
              String ctgrArg = (String)args.get(3);
              if (ctgrArg == null) {
                throw new NullPointerException("ctgrArg unexpectedly null.");
              }
              String cityArg = (String)args.get(4);
              if (cityArg == null) {
                throw new NullPointerException("cityArg unexpectedly null.");
              }
              Object centerArg = (Object)args.get(5);
              Number radiusInMetersArg = (Number)args.get(6);
              Boolean isDistanceSortArg = (Boolean)args.get(7);
              String extensionsArg = (String)args.get(8);
              if (extensionsArg == null) {
                throw new NullPointerException("extensionsArg unexpectedly null.");
              }
              Result<ApiResult> resultCallback = new Result<ApiResult>() {
                public void success(ApiResult result) {
                  wrapped.put("result", result);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.searchPoi((pageNumArg == null) ? null : pageNumArg.longValue(), (pageSizeArg == null) ? null : pageSizeArg.longValue(), queryArg, ctgrArg, cityArg, centerArg, (radiusInMetersArg == null) ? null : radiusInMetersArg.longValue(), isDistanceSortArg, extensionsArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
