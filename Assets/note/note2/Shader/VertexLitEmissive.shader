Shader "Note2/VertexLitEmissive"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Emission ("Emission", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Emission;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // 逐顶点光照计算
                float3 normal = normalize(v.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0, dot(normal, lightDir));
                float3 diffuse = NdotL * _LightColor0.rgb;

                // 自发光计算
                float3 emissive = _Emission.rgb;

                o.color = diffuse + emissive;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                return tex * fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}