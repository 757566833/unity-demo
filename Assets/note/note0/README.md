# shader

## shader结构

```shader
Shader "Note2/PixelLitSpecular"
{
    Properties
    {
        <!-- 这里面是一些属性，会出现在unity editor面板中 -->
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        <!-- 这里面是subshader，可以有多个，unity会根据平台和设置选择一个 -->
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass {
            <!-- 这里是可编程管线的具体渲染指令，可以有多个，每一个会渲染一次 -->
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            <!-- 这里是从cpu索要的数据，可以用内置的，也可以自定义，过多的属性会消耗带宽 -->
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            <!-- 这是 vertex to fragment 的数据结构，顶点处理结束后会传递给像素渲染函数 -->
            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            <!-- 要和Properties 重名才会双向绑定 -->
            sampler2D _MainTex;
            fixed4 _Color;

            <!-- 逐顶点渲染函数，逻辑尽量放到这里，性能高，但是有一些特效放到这里处理不够细腻 -->
            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            <!-- 像素处理函数，逐像素渲染函数，在这里处理会很细腻，但是性能会降低 -->
            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    
    }

}
```

## LOD

lod相当于全局变量，用来区分采用哪个SubShader渲染  

可以设置全局变量，也可以根据镜头由远及近设置

使用 LOD Group 实现由近及远逐渐降低 LOD

创建不同的 LOD 级别：

为你的对象创建多个不同复杂度的模型或 Shader，并为每个模型/Shader 设置不同的 LOD 值。

添加 LOD Group 组件：

在 Unity 编辑器中，选中你的对象，然后点击 Add Component，选择 LOD Group。

配置 LOD Group：

在 LOD Group 组件中，点击 Add LOD 按钮，为对象添加多个 LOD 级别。

将不同复杂度的模型或 Shader 分配给不同的 LOD 级别。

设置 LOD 阈值：

使用滑块设置每个 LOD 级别的阈值。阈值决定了在摄像机距离对象的不同范围内使用哪个 LOD 级别。
