Shader "Note2/PixelLitDiffuse"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _LightColor ("Light Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 lightDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _LightColor;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                o.normal = normalize(mul((float3x3)unity_WorldToObject, v.normal));
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(i.lightDir);
                float diff = max(0, dot(normal, lightDir));

                half4 texColor = tex2D(_MainTex, i.uv) * _Color;
                texColor.rgb *= diff * _LightColor.rgb;
                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

