// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyFriend/SH_Miel1"
{
	Properties
	{
		_Color0("Color 0", Color) = (0.5993309,0,1,1)
		_Tessalation("Tessalation", Range( 1 , 10)) = 1
		_EdgeDistance("Edge Distance", Float) = 1
		_EdgePower("Edge Power", Float) = 1
		[HDR]_EmissiveColor("Emissive Color", Color) = (0.7789856,0.25,1,0)
		_PowerHeight("Power Height", Range( -10 , 10)) = 1
		_Texture2("Texture 2", 2D) = "white" {}
		[HDR]_ColorMoveTexture("Color MoveTexture", Color) = (2.694309,0.114381,2.59616,0)
		[HDR][Gamma]_ColorHighlight("Color Highlight", Color) = (2.880382,0.02057416,3.929664,0)
		_Oppacity("Oppacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _PowerHeight;
		uniform float4 _Color0;
		uniform sampler2D _Texture2;
		uniform float4 _ColorHighlight;
		uniform float4 _ColorMoveTexture;
		uniform float4 _EmissiveColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance;
		uniform float _EdgePower;
		uniform float _Oppacity;
		uniform float _Tessalation;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_2 = (_Tessalation).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float3 height111 = ( ase_vertexNormal * _PowerHeight );
			float4 _Vector3 = float4(1,1,0,0);
			float2 appendResult119 = (float2(_Vector3.x , _Vector3.y));
			float2 appendResult120 = (float2(_Vector3.z , _Vector3.w));
			float2 uv_TexCoord8 = v.texcoord.xy * float2( 3,3 );
			float2 UVControll123 = ( appendResult119 * ( appendResult120 + uv_TexCoord8 ) );
			float2 panner10 = ( ( _Time.y * 0.8 ) * float3(1,1,1).xy + UVControll123);
			float simplePerlin2D15 = snoise( panner10 );
			simplePerlin2D15 = simplePerlin2D15*0.5 + 0.5;
			float2 panner39 = ( ( _Time.y * 0.8 ) * float3(-1,-1,-1).xy + UVControll123);
			float simplePerlin2D41 = snoise( panner39 );
			simplePerlin2D41 = simplePerlin2D41*0.5 + 0.5;
			float temp_output_42_0 = ( simplePerlin2D15 * simplePerlin2D41 );
			v.vertex.xyz += ( height111 * temp_output_42_0 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Vector3 = float4(1,1,0,0);
			float2 appendResult119 = (float2(_Vector3.x , _Vector3.y));
			float2 appendResult120 = (float2(_Vector3.z , _Vector3.w));
			float2 uv_TexCoord8 = i.uv_texcoord * float2( 3,3 );
			float2 UVControll123 = ( appendResult119 * ( appendResult120 + uv_TexCoord8 ) );
			float2 panner10 = ( ( _Time.y * 0.8 ) * float3(1,1,1).xy + UVControll123);
			float simplePerlin2D15 = snoise( panner10 );
			simplePerlin2D15 = simplePerlin2D15*0.5 + 0.5;
			float2 panner39 = ( ( _Time.y * 0.8 ) * float3(-1,-1,-1).xy + UVControll123);
			float simplePerlin2D41 = snoise( panner39 );
			simplePerlin2D41 = simplePerlin2D41*0.5 + 0.5;
			float temp_output_42_0 = ( simplePerlin2D15 * simplePerlin2D41 );
			float temp_output_128_0 = pow( temp_output_42_0 , 4.0 );
			float4 temp_cast_2 = (0.4).xxxx;
			float4 temp_output_131_0 = ( temp_output_128_0 * _ColorMoveTexture );
			float4 temp_cast_3 = (2.0).xxxx;
			o.Albedo = ( ( _Color0 + pow( ( ( temp_output_128_0 * tex2D( _Texture2, UVControll123 ) ) * _ColorHighlight ) , temp_cast_2 ) ) + pow( ( temp_output_131_0 / 0.08 ) , temp_cast_3 ) ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth46 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth46 = abs( ( screenDepth46 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float clampResult56 = clamp( ( ( 1.0 - distanceDepth46 ) * _EdgePower ) , 0.0 , 1.0 );
			float4 Edge52 = ( _EmissiveColor * clampResult56 );
			float4 EmissiveColor66 = _EmissiveColor;
			o.Emission = saturate( ( Edge52 + ( pow( temp_output_42_0 , 3.0 ) * EmissiveColor66 ) ) ).rgb;
			o.Smoothness = temp_output_131_0.r;
			o.Alpha = _Oppacity;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
631;73;694;617;-1548.396;-581.6129;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;124;-2388.555,-2052.582;Inherit;False;1156.933;695.9143;;7;118;8;120;121;119;122;123;UV Controll;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;118;-2338.555,-1958.81;Inherit;False;Constant;_Vector3;Vector 3;8;0;Create;True;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;120;-1987.037,-1814.775;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2086.928,-1658.667;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;54;-2727.126,217.0283;Inherit;False;2082.402;1674.212;Comment;9;43;14;12;4;31;10;15;42;101;Boiling;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-1992.055,-2002.582;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-1807.928,-1769.529;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;43;-2677.126,1111.639;Inherit;False;1496.505;779.6007;Dupplique et inverse la valeur en Z de façon à pouvoir blend et les deux et créer l'effet "boiling";8;34;35;36;38;39;41;102;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1617.18,-1919.018;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2208.792,1775.24;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2653.519,915.2175;Inherit;False;Constant;_Speed;Speed;0;0;Create;True;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2621.334,648.0531;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-2223.405,1504.474;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-1455.622,-1920.739;Inherit;False;UVControll;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2674.901,2066.845;Inherit;False;2056.254;568.5269;Comment;10;52;57;50;49;48;46;47;58;59;66;Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;38;-2097.722,1345.353;Inherit;False;Constant;_Vector2;Vector 2;4;0;Create;True;0;0;False;0;False;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2365.082,716.8627;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-2593.413,1165.227;Inherit;False;123;UVControll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1967.153,1570.78;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2633.676,2133.65;Inherit;False;Property;_EdgeDistance;Edge Distance;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;31;-2352,416;Inherit;False;Constant;_Vector1;Vector 1;4;0;Create;True;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;101;-2640,272;Inherit;False;123;UVControll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-2076.859,312.4614;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;46;-2358.236,2117.109;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;39;-1748.109,1172.483;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2133.594,2352.206;Inherit;False;Property;_EdgePower;Edge Power;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;147;-278.3526,1175.294;Inherit;False;1547.903;624.7838;Je récupère mon noise et j'utilise un power pour accentuer l'effet de reflet. J'utilise un divide ensuite pour rendre mon effet plus net et je rajoute un power pour accentuer d'autant plus celui-ci.;8;133;144;131;146;143;145;128;127;Glossy;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;192;-334.4406,1970.74;Inherit;False;1688.001;635.3201;J'ai créé une texture que j'utilise comme noise. Je le mutiplie avec mon reflet pour donner l'impression que les bulles aparaissent et disparaissent. Pour finir j'y ajoute um power pour récupérer plus de bulles.;8;170;191;149;178;176;177;182;181;Bubbles;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;49;-2039.509,2152.687;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1427.465,1282.179;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;-1729.763,309.269;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-879.7263,973.7506;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-228.3527,1254.815;Inherit;False;Constant;_Float4;Float 4;9;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;170;-284.4406,2223.502;Inherit;True;Property;_Texture2;Texture 2;9;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;191;-200.7275,2490.06;Inherit;False;123;UVControll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1849.451,2301.429;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1611.277,2260.663;Inherit;False;221;209;Invert Effect;1;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;112;-2445.036,-2616.576;Inherit;False;1248.477;406.1256;Comment;4;108;109;111;115;Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;56;-1561.277,2310.663;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;-1348.82,2090.796;Inherit;False;Property;_EmissiveColor;Emissive Color;7;1;[HDR];Create;True;0;0;False;0;False;0.7789856,0.25,1,0;1,0,0.9508462,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;128;-16.2995,1225.294;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-442.9208,104.2231;Inherit;False;1300.093;656.1328;Je créé ici un faux reflet sur les partie haute de mon mesh pour créer l'effet de brillance.  Mon mesh étant déformé selon mon noise je récupère ce même noise pour avoir les hauteurs. ;7;69;55;61;67;64;65;125;Get Upper Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;149;34.4712,2218.438;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;465.3834,2020.74;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-408.8438,241.7766;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1052.563,2299.115;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-935.961,2108.672;Inherit;False;EmissiveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;178;451.2567,2269.919;Inherit;False;Property;_ColorHighlight;Color Highlight;11;2;[HDR];[Gamma];Create;True;0;0;False;0;False;2.880382,0.02057416,3.929664,0;2.880382,0.02057416,3.929664,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-2423.024,-2319.951;Inherit;False;Property;_PowerHeight;Power Height;8;0;Create;True;0;0;False;0;False;1;1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;115;-2409.535,-2502.327;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;133;-113.6952,1568.53;Inherit;False;Property;_ColorMoveTexture;Color MoveTexture;10;1;[HDR];Create;True;0;0;False;0;False;2.694309,0.114381,2.59616,0;2.694309,0.114381,2.59616,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;144;401.3454,1591.684;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;767.946,2024.323;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;64;-235.6282,264.054;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;271.3078,1297.221;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-216.9668,524.9154;Inherit;False;66;EmissiveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-796.0891,2283.303;Inherit;True;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;182;900.1508,2314.503;Inherit;False;Constant;_Float7;Float 7;8;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2151.393,-2468.584;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;146;710.1827,1684.078;Inherit;False;Constant;_Float6;Float 6;8;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-1420.559,-2456.545;Inherit;False;height;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;143;643.7292,1365.458;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;36.20251,369.1614;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;1155.637,130.0672;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;False;0;False;0.5993309,0,1,1;0.6029677,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;181;1093.56,2137.496;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;43.15237,206.1745;Inherit;False;52;Edge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;1524.212,249.1537;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;102.4168,901.8059;Inherit;False;111;height;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;145;1009.551,1530.352;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;345.2099,251.3205;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2198.921,-1140.491;Inherit;False;790.0068;313.7576;World Space UVs;3;16;17;18;World Space UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2678.24,-542.2303;Inherit;False;1761.676;605.7773;Non utilisé;10;78;79;72;83;82;74;81;80;84;103;Reflections;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-1124.113,-317.9546;Inherit;False;Reflection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-2604.348,1279.071;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1707.404,-159.3391;Inherit;False;66;EmissiveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1415.742,-333.095;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2647.645,-266.3926;Inherit;False;Property;_Speedreflection;Speed reflection;1;0;Create;True;0;0;False;0;False;0.7463495;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-2283.579,-130.8108;Inherit;False;18;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1637.918,-1063.728;Inherit;False;WorldSpaceUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1907.957,-150.5975;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;1755.593,943.1168;Inherit;False;Property;_Tessalation;Tessalation;3;0;Create;True;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2350.483,-443.5803;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;466.4954,899.2957;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;125;659.9889,287.4303;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;188;1830.974,347.8779;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;74;-1736.106,-412.021;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;1782.396,803.6129;Inherit;False;Property;_Oppacity;Oppacity;12;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1906.943,-1080.734;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-2148.921,-1090.491;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;78;-2612.455,-500.1622;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;72;-1955.897,-430.6883;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2096.052,603.7712;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;MyFriend/SH_Miel1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;120;0;118;3
WireConnection;120;1;118;4
WireConnection;119;0;118;1
WireConnection;119;1;118;2
WireConnection;121;0;120;0
WireConnection;121;1;8;0
WireConnection;122;0;119;0
WireConnection;122;1;121;0
WireConnection;123;0;122;0
WireConnection;4;0;12;0
WireConnection;4;1;14;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;10;0;101;0
WireConnection;10;2;31;0
WireConnection;10;1;4;0
WireConnection;46;0;47;0
WireConnection;39;0;102;0
WireConnection;39;2;38;0
WireConnection;39;1;36;0
WireConnection;49;0;46;0
WireConnection;41;0;39;0
WireConnection;15;0;10;0
WireConnection;42;0;15;0
WireConnection;42;1;41;0
WireConnection;50;0;49;0
WireConnection;50;1;48;0
WireConnection;56;0;50;0
WireConnection;128;0;42;0
WireConnection;128;1;127;0
WireConnection;149;0;170;0
WireConnection;149;1;191;0
WireConnection;176;0;128;0
WireConnection;176;1;149;0
WireConnection;59;0;58;0
WireConnection;59;1;56;0
WireConnection;66;0;58;0
WireConnection;177;0;176;0
WireConnection;177;1;178;0
WireConnection;64;0;42;0
WireConnection;64;1;65;0
WireConnection;131;0;128;0
WireConnection;131;1;133;0
WireConnection;52;0;59;0
WireConnection;109;0;115;0
WireConnection;109;1;108;0
WireConnection;111;0;109;0
WireConnection;143;0;131;0
WireConnection;143;1;144;0
WireConnection;61;0;64;0
WireConnection;61;1;67;0
WireConnection;181;0;177;0
WireConnection;181;1;182;0
WireConnection;134;0;27;0
WireConnection;134;1;181;0
WireConnection;145;0;143;0
WireConnection;145;1;146;0
WireConnection;69;0;55;0
WireConnection;69;1;61;0
WireConnection;84;0;83;0
WireConnection;83;0;74;0
WireConnection;83;1;82;0
WireConnection;18;0;17;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;116;0;113;0
WireConnection;116;1;42;0
WireConnection;125;0;69;0
WireConnection;188;0;134;0
WireConnection;188;1;145;0
WireConnection;74;0;72;0
WireConnection;74;1;81;0
WireConnection;17;0;16;1
WireConnection;17;1;16;2
WireConnection;17;2;16;3
WireConnection;72;0;103;0
WireConnection;72;1;79;0
WireConnection;0;0;188;0
WireConnection;0;2;125;0
WireConnection;0;4;131;0
WireConnection;0;9;196;0
WireConnection;0;11;116;0
WireConnection;0;14;28;0
ASEEND*/
//CHKSM=3D77EECA8A70A107E67151761F95F88F48BEA639