// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Miel5"
{
	Properties
	{
		_Gradient("Gradient", 2D) = "white" {}
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_fresnel("fresnel", Range( 0 , 1)) = 1
		_PowerHeight("Power Height", Range( -10 , 10)) = 1
		_fresnelOpacity("fresnelOpacity", Range( 0 , 1)) = 1
		_fresnelBias("fresnelBias", Range( 0 , 1)) = 0
		_fresnelBiasOpacity("fresnelBiasOpacity", Range( 0 , 1)) = 0
		_DepthFade("DepthFade", Float) = 0
		_DepthFadeOpacity("DepthFadeOpacity", Float) = 0
		_Glossiness("Glossiness", Float) = 0
		_Transluency("Transluency", Float) = 10
		_Bubbles("Bubbles", 2D) = "white" {}
		_ParralaxScale("Parralax Scale", Float) = 1
		_Oppacity("Oppacity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 screenPos;
			float2 uv_texcoord;
			float3 viewDir;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float _PowerHeight;
		uniform sampler2D _Gradient;
		uniform float _fresnel;
		uniform float _fresnelBias;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade;
		uniform sampler2D _Bubbles;
		uniform float4 _Bubbles_ST;
		uniform float _ParralaxScale;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Glossiness;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _Transluency;
		uniform float _DepthFadeOpacity;
		uniform float _fresnelOpacity;
		uniform float _fresnelBiasOpacity;
		uniform float _Oppacity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 height139 = ( ase_vertexNormal * _PowerHeight );
			float4 _Vector1 = float4(1,1,0,0);
			float2 appendResult129 = (float2(_Vector1.x , _Vector1.y));
			float2 appendResult127 = (float2(_Vector1.z , _Vector1.w));
			float2 uv_TexCoord128 = v.texcoord.xy * float2( 3,3 );
			float2 UVControll132 = ( appendResult129 * ( appendResult127 + uv_TexCoord128 ) );
			float2 panner119 = ( ( _Time.y * 0.8 ) * float3(1,1,1).xy + UVControll132);
			float simplePerlin2D122 = snoise( panner119 );
			simplePerlin2D122 = simplePerlin2D122*0.5 + 0.5;
			float2 panner120 = ( ( _Time.y * 0.8 ) * float3(-1,-1,-1).xy + UVControll132);
			float simplePerlin2D121 = snoise( panner120 );
			simplePerlin2D121 = simplePerlin2D121*0.5 + 0.5;
			v.vertex.xyz += ( height139 * ( simplePerlin2D122 * simplePerlin2D121 ) );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult34 = dot( ase_normWorldNormal , ase_worldViewDir );
			float smoothstepResult35 = smoothstep( _fresnel , ( _fresnel + _fresnelBias ) , dotResult34);
			float temp_output_16_0 = saturate( smoothstepResult35 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth43 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth43 = saturate( abs( ( screenDepth43 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) ) );
			float temp_output_45_0 = ( temp_output_16_0 * distanceDepth43 );
			float2 uv_Bubbles = i.uv_texcoord * _Bubbles_ST.xy + _Bubbles_ST.zw;
			float2 Offset55 = ( ( _ParralaxScale - 1 ) * i.viewDir.xy * 1.0 ) + uv_Bubbles;
			float2 Offset67 = ( ( ( 0.5 * _ParralaxScale ) - 1 ) * i.viewDir.xy * 1.0 ) + ( float2( 0.5,0.5 ) + uv_Bubbles );
			float2 appendResult22 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float4 screenColor2 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,appendResult22);
			o.Albedo = ( tex2D( _Gradient, ( temp_output_45_0 + ( tex2D( _Bubbles, Offset55 ) + tex2D( _Bubbles, Offset67 ) ) ).rg ) * saturate( ( temp_output_45_0 + screenColor2 ) ) ).rgb;
			o.Smoothness = _Glossiness;
			float3 temp_cast_2 = (_Transluency).xxx;
			o.Translucency = temp_cast_2;
			float screenDepth46 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth46 = saturate( abs( ( screenDepth46 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeOpacity ) ) );
			float smoothstepResult51 = smoothstep( _fresnelOpacity , ( _fresnelOpacity + _fresnelBiasOpacity ) , dotResult34);
			o.Alpha = ( saturate( ( distanceDepth46 * smoothstepResult51 ) ) * _Oppacity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
936;73;706;601;3277.558;1687.057;5.805907;True;False
Node;AmplifyShaderEditor.CommentaryNode;125;-4184.078,-3151.296;Inherit;False;1156.933;695.9143;;7;132;131;130;129;128;127;126;UV Controll;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;126;-4134.078,-3057.524;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;127;-3782.56,-2913.489;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-3882.451,-2757.381;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;107;-4569.053,-2179.626;Inherit;False;2082.402;1674.212;Comment;9;123;122;119;118;117;114;111;110;108;Boiling;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-3603.451,-2868.243;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-3787.578,-3101.296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;70;-3742.429,1662.566;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-4133.17,1426.527;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-3850.188,2049.702;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-4148.176,1677.486;Inherit;False;Property;_ParralaxScale;Parralax Scale;18;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-2812.648,-203.2894;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;-2612.496,41.20689;Inherit;False;Property;_fresnel;fresnel;8;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-2784.648,-36.28939;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;37;-2614.918,151.8342;Inherit;False;Property;_fresnelBias;fresnelBias;11;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2332.643,91.03036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-3608.429,2061.566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;-4519.053,-1285.016;Inherit;False;1496.505;779.6007;Dupplique et inverse la valeur en Z de façon à pouvoir blend et les deux et créer l'effet "boiling";8;124;121;120;116;115;113;112;109;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-3412.703,-3017.732;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-4128.17,1569.527;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;60;-4114.171,1792.527;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-3550.429,1744.566;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;34;-2457.648,-132.1947;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;21;-1290.276,201.1727;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;35;-2199.986,-13.09672;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2277.786,671.1459;Inherit;False;Property;_fresnelOpacity;fresnelOpacity;10;0;Create;True;0;0;False;0;False;1;0.152;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2275.077,265.5309;Inherit;False;Property;_DepthFade;DepthFade;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2280.207,781.7732;Inherit;False;Property;_fresnelBiasOpacity;fresnelBiasOpacity;12;0;Create;True;0;0;False;0;False;0;0.232;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;111;-4463.261,-1748.601;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;67;-3373.188,1777.702;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-3251.145,-3019.453;Inherit;False;UVControll;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;112;-4065.332,-892.1805;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-4050.719,-621.4146;Inherit;False;Constant;_Float6;Float 6;2;0;Create;True;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;55;-3812.257,1429.722;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;57;-3946.343,1014.018;Inherit;True;Property;_Bubbles;Bubbles;17;0;Create;True;0;0;False;0;False;6cb9b51fcb88d314e8a7004bb4c42aaf;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;135;-4028.931,-4016.823;Inherit;False;1248.477;406.1256;Comment;4;139;138;137;136;Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-4495.445,-1481.437;Inherit;False;Constant;_Speed;Speed;0;0;Create;True;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-4481.927,-2124.655;Inherit;False;132;UVControll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;16;-1959.149,-7.789397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;43;-2086.48,242.0842;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2001.233,499.625;Inherit;False;Property;_DepthFadeOpacity;DepthFadeOpacity;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1997.933,720.9694;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1072.276,229.1727;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;64;-2990.676,1506.478;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;113;-3939.648,-1051.302;Inherit;False;Constant;_Vector3;Vector 3;4;0;Create;True;0;0;False;0;False;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-3809.08,-825.8745;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-4207.009,-1679.792;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;117;-4193.927,-1980.655;Inherit;False;Constant;_Vector2;Vector 2;4;0;Create;True;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;115;-4435.34,-1231.427;Inherit;False;132;UVControll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;59;-3299.456,1018.404;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;137;-3993.43,-3902.574;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;136;-4006.919,-3720.198;Inherit;False;Property;_PowerHeight;Power Height;9;0;Create;True;0;0;False;0;False;1;1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;46;-1776.636,482.407;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;120;-3590.036,-1224.172;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-2239.382,1015.814;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-3735.288,-3868.831;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;119;-3918.785,-2084.193;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1563.052,72.50838;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;51;-1865.276,616.8423;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;2;-740.1191,222.5059;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;28;-1651.347,-323.6032;Inherit;True;Property;_Gradient;Gradient;0;0;Create;True;0;0;False;0;False;3d09624c0cd6efc43ba7be9a9d2d0182;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-530.655,56.33125;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1500.416,543.7596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;121;-3269.392,-1114.476;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;122;-3571.689,-2087.385;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1585.093,989.1219;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-3004.454,-3856.792;Inherit;False;height;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;27;-1359.435,-100.0234;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;53;-935.2219,538.0862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-935.6902,810.5532;Inherit;False;Property;_Oppacity;Oppacity;19;0;Create;True;0;0;False;0;False;1;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-2721.653,-1422.904;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-2305.7,-1214.161;Inherit;False;139;height;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;41;-376.413,56.6138;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;99.46801,5.285951;Inherit;False;Property;_Glossiness;Glossiness;15;0;Create;True;0;0;False;0;False;0;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2134.506,-409.0036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;74;-2565.502,-492.3022;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;105;85.41793,85.79586;Inherit;False;Property;_Transluency;Transluency;16;0;Create;True;0;0;False;0;False;10;7.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2155.054,-276.5829;Inherit;False;Constant;_Float3;Float 3;12;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;106;-1639.982,-412.0313;Inherit;False;0;3;2;1,0.9397521,0,0;1,0.4407697,0,0.8441138;1,0.2306138,0,1;1,0;1,0.9941252;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1770.081,-67.63505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-200.1819,-89.60466;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2306.881,-387.3139;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;78;-2286.461,-582.9563;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;101;-3254.654,385.9662;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;96;-3234.774,709.765;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3685.005,545.8805;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;124;-4446.274,-1117.583;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-3680.823,621.1952;Inherit;False;Constant;_Float5;Float 5;12;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-3699.827,342.8866;Inherit;True;Property;_bubullenormal;bubulle normal;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1941.622,-1216.671;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;97;-3673.081,772.6412;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1970.122,-322.2452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-721.1208,620.738;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;376.1074,-86.06374;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SH_Miel5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;127;0;126;3
WireConnection;127;1;126;4
WireConnection;130;0;127;0
WireConnection;130;1;128;0
WireConnection;129;0;126;1
WireConnection;129;1;126;2
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;72;0;66;0
WireConnection;72;1;62;0
WireConnection;131;0;129;0
WireConnection;131;1;130;0
WireConnection;71;0;70;0
WireConnection;71;1;58;0
WireConnection;34;0;9;0
WireConnection;34;1;8;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;35;2;38;0
WireConnection;67;0;71;0
WireConnection;67;1;72;0
WireConnection;67;2;61;0
WireConnection;67;3;60;0
WireConnection;132;0;131;0
WireConnection;55;0;58;0
WireConnection;55;1;62;0
WireConnection;55;2;61;0
WireConnection;55;3;60;0
WireConnection;16;0;35;0
WireConnection;43;0;44;0
WireConnection;49;0;48;0
WireConnection;49;1;50;0
WireConnection;22;0;21;1
WireConnection;22;1;21;2
WireConnection;64;0;57;0
WireConnection;64;1;67;0
WireConnection;116;0;112;0
WireConnection;116;1;109;0
WireConnection;114;0;111;0
WireConnection;114;1;110;0
WireConnection;59;0;57;0
WireConnection;59;1;55;0
WireConnection;46;0;47;0
WireConnection;120;0;115;0
WireConnection;120;2;113;0
WireConnection;120;1;116;0
WireConnection;91;0;59;0
WireConnection;91;1;64;0
WireConnection;138;0;137;0
WireConnection;138;1;136;0
WireConnection;119;0;118;0
WireConnection;119;2;117;0
WireConnection;119;1;114;0
WireConnection;45;0;16;0
WireConnection;45;1;43;0
WireConnection;51;0;34;0
WireConnection;51;1;48;0
WireConnection;51;2;49;0
WireConnection;2;0;22;0
WireConnection;40;0;45;0
WireConnection;40;1;2;0
WireConnection;52;0;46;0
WireConnection;52;1;51;0
WireConnection;121;0;120;0
WireConnection;122;0;119;0
WireConnection;90;0;45;0
WireConnection;90;1;91;0
WireConnection;139;0;138;0
WireConnection;27;0;28;0
WireConnection;27;1;90;0
WireConnection;53;0;52;0
WireConnection;123;0;122;0
WireConnection;123;1;121;0
WireConnection;41;0;40;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;83;0;81;0
WireConnection;83;1;16;0
WireConnection;5;0;27;0
WireConnection;5;1;41;0
WireConnection;78;0;9;0
WireConnection;78;1;74;0
WireConnection;101;0;100;0
WireConnection;101;1;102;0
WireConnection;101;2;103;0
WireConnection;96;0;100;0
WireConnection;96;1;97;0
WireConnection;133;0;134;0
WireConnection;133;1;123;0
WireConnection;81;0;79;0
WireConnection;81;1;82;0
WireConnection;92;0;53;0
WireConnection;92;1;93;0
WireConnection;0;0;5;0
WireConnection;0;4;54;0
WireConnection;0;7;105;0
WireConnection;0;9;92;0
WireConnection;0;11;133;0
ASEEND*/
//CHKSM=584921EEAFA30F67944E94FCAE2D2B59B425FC7D