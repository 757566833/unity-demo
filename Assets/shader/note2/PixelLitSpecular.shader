Shader "Note2/PixelLitSpecular"
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
                float3 color : COLOR;
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

                float3 normal = normalize(mul((float3x3)unity_WorldToObject, v.normal));
                float3 viewDir = normalize(WorldSpaceViewDir(v.vertex));
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float diff = max(0, dot(normal, lightDir));
                half3 diffuse = diff * _LightColor0.rgb;

                float3 halfDir = normalize(lightDir + viewDir); 
                float spec = pow(max(0, dot(normal, halfDir)), _Shininess * 128);
                half3 specular = spec * _SpecColor2.rgb;

                half3 lighting = diffuse + specular;
                lighting = lighting * _Color.rgb;

                o.color = lighting;

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 texColor = tex2D(_MainTex, i.uv);
                half3 color = i.color * texColor.rgb;
                return half4(color, texColor.a);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}