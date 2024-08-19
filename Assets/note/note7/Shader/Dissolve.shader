Shader "Note7/Dissolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissolveTex ("Dissolve", 2D) = "white" {}
        _RampTex ("Ramp", 2D) = "white" {}
        _Clip ("Clip",Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DissolveTex;
            float4 _DissolveTex_ST;
            sampler2D _RampTex;
            float4 _RampTex_ST;
            float _Clip;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _DissolveTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 main =  i.uv.xy;
                float2 dissolveUV =  i.uv.zw;
                fixed4 dissolve = tex2D(_DissolveTex, dissolveUV);
                // 比_Clip 小的直接删除
                clip(dissolve.r-_Clip);

                fixed4 ramp = tex2D(_RampTex,smoothstep(_Clip,_Clip+0.1,dissolve.r));

                
                fixed4 col = tex2D(_MainTex, main);
                col += ramp;
                return col;
            }
            ENDCG
        }
    }
}
