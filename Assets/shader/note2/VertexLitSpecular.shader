Shader "Note2/VertexLitSpecular"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SpecColor2 ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(0.03, 1)) = 0.078125
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
            #include "Lighting.cginc"

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
                float3 viewDir : TEXCOORD2;
                float3 lightDir : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _SpecColor2;
            float _Shininess;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.normal = normalize(mul((float3x3)unity_WorldToObject, v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 texColor = tex2D(_MainTex, i.uv) * _Color;

                float diff = max(0, dot(i.normal, i.lightDir));
                half3 diffuse = diff * _LightColor0.rgb;

                float3 halfDir = normalize(i.lightDir + i.viewDir);
                float spec = pow(max(0, dot(i.normal, halfDir)), _Shininess * 128);
                half3 specular = spec * _SpecColor2.rgb;
                half3 color = diffuse + specular;
                color = color * texColor.rgb;

                return half4(color, texColor.a);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
