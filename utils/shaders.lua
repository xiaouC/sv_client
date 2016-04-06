
local vertex_shader_position_texture_color = [[
    attribute vec4 a_position;
    attribute vec2 a_texCoord;
    attribute vec4 a_color;
    
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    
    void main()
    {
        gl_Position = CC_MVPMatrix * a_position;
        v_fragmentColor = a_color;
        v_texCoord = a_texCoord;
    }
]]

-- 滤波处理函数
local dip_filter = [[
    vec4 dip_filter( mat3 _filter, sampler2D tex, vec2 xy, vec2 texSize )
    {
        mat3 _filter_x = mat3( -1.0, 0.0, 1.0,
                               -1.0, 0.0, 1.0,
                               -1.0, 0.0, 1.0 );
        mat3 _filter_y = mat3( -1.0, -1.0, -1.0,
                               0.0, 0.0, 0.0,
                               1.0, 1.0, 1.0 );

        vec4 final_color = vec4( 0.0, 0.0, 0.0, 0.0 );

        for( int i=0; i < 3; i++ )
        {
            for( int j=0; j < 3; j++ )
            {
                vec2 xy_new = vec2( xy.x + _filter_x[i][j], xy.y + _filter_y[i][j] );
                vec2 uv = vec2( xy_new.x / texSize.x, xy_new.y / texSize.y );

                vec4 temp_color = texture2D( tex, uv ) * _filter[i][j];
                final_color = final_color + temp_color;
            }
        }

        return final_color;
    }
]]

local filter_param_smooth = [[
    mat3 _filter = mat3( 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0,
                         1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0,
                         1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0 );
]]
local filter_param_gaussian = [[
    mat3 _filter = mat3( 1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0,
                         2.0 / 16.0, 4.0 / 16.0, 2.0 / 16.0,
                         1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0 );
]]
local filter_param_laplacian = [[
    mat3 _filter = mat3( 1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0,
                         2.0 / 16.0, 4.0 / 16.0, 2.0 / 16.0,
                         1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0 );
]]
local filter_param_stroke = [[
    mat3 _filter = mat3( -0.5, -1.0, 0.0,
                         1.0, 0.0, 1.0,
                         -0.0, 1.0, 0.5 );
]]

local custom_shaders = {
    {
        shader_name = 'position_texture_color_gray',
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;

            void main()
            {
                vec4 color = v_fragmentColor * texture2D( CC_Texture0, v_texCoord );
                float f = 0.3 * color.r + 0.6 * color.g + 0.1 * color.b;
                gl_FragColor = vec4( f, f, f, color.a );
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_texture_flow',
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
        #ifdef GL_ES
        precision highp float;
        #endif

        varying vec4 v_fragmentColor;
        varying vec2 v_texCoord;
        uniform sampler2D CC_Texture0;
        uniform vec4 CC_Custom;

        void main()
        {
            vec2 uv = v_texCoord.xy + CC_Custom.xy;
            vec4 color = v_fragmentColor * texture2D( CC_Texture0, uv );
            gl_FragColor = vec4( color.r, color.g, color.b, color.a );
        }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_HDR',                 -- 伪 HDR
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;

            void main()
            {
                vec4 color = v_fragmentColor * texture2D( CC_Texture0, v_texCoord );
                float gray = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;

                float k = 2.0;
                float b = ( 4.0 * k - 1.0 );
                float a = 1.0 - b;
                float f = gray * ( a * gray + b );

                gl_FragColor = f * color;
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_relief',              -- 浮雕效果
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;

            void main()
            {
                vec2 upLeftUV = vec2( v_texCoord.x - 1.0 / CC_Custom.x, v_texCoord.y - 1.0 / CC_Custom.y );

                vec4 color = v_fragmentColor * texture2D( CC_Texture0, v_texCoord );
                vec4 upLeftColor = texture2D( CC_Texture0, upLeftUV );

                vec4 delColor = color - upLeftColor;

                float gray = 0.3 * delColor.r + 0.59 * delColor.g + 0.11 * delColor.b;
                gray += 0.5;
                gray *= color.a;

                gl_FragColor = vec4( gray, gray, gray, color.a );
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_stroke',              -- 描边
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;
        ]] .. dip_filter .. [[
            void main()
            {
                vec4 color = v_fragmentColor * texture2D( CC_Texture0, v_texCoord );
                vec2 intXY = vec2( v_texCoord.x * CC_Custom.x, v_texCoord.y * CC_Custom.y );

        ]] .. filter_param_stroke .. [[

                vec4 delColor = dip_filter( _filter, CC_Texture0, intXY, CC_Custom.xy );
                float delGray = 0.3 * delColor.r + 0.59 * delColor.g + 0.11 * delColor.b;

                if( delGray < 0.0 )
                    delGray = -1.0 * delGray;

                delGray = ( 1.0 - delGray ) * color.a;

                gl_FragColor = vec4( delGray, delGray, delGray, color.a );
                //gl_FragColor = vec4( 1.0, 0.0, 0.0, 0.5 );
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_ellipse_mask_layer',              -- 遮罩
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;
            uniform vec4 CC_Custom_Ex;

            void main()
            {
                float x = v_texCoord.x;         // 点的坐标
                float y = v_texCoord.y;

                float x1 = CC_Custom.x;         // 椭圆原点坐标
                float y1 = CC_Custom.y;
                float a = CC_Custom.z;          // 椭圆长短半径
                float b = CC_Custom.w;

                float temp_1 = 0.5;

                float dis = ( ( x - x1 ) * ( x - x1 ) ) / ( a * a ) + ( ( y - y1 ) * ( y - y1 ) ) / ( b * b );
                if( dis < 1.0 )
                {
                    if( dis > temp_1 )
                    {
                        gl_FragColor = v_fragmentColor * ( ( dis - temp_1 ) / ( 1.0 - temp_1 ) );
                    }
                    else
                    {
                        gl_FragColor = vec4( 0.0, 0.0, 0.0, 0.0 );
                    }
                }
                else
                {
                    float x2 = CC_Custom_Ex.x;         // 椭圆原点坐标
                    float y2 = CC_Custom_Ex.y;
                    float a2 = CC_Custom_Ex.z;          // 椭圆长短半径
                    float b2 = CC_Custom_Ex.w;

                    float dis2 = ( ( x - x2 ) * ( x - x2 ) ) / ( a2 * a2 ) + ( ( y - y2 ) * ( y - y2 ) ) / ( b2 * b2 );
                    if( dis2 < 1.0 )
                    {
                        if( dis2 > temp_1 )
                        {
                            gl_FragColor = v_fragmentColor * ( ( dis2 - temp_1 ) / ( 1.0 - temp_1 ) );
                        }
                        else
                        {
                            gl_FragColor = vec4( 0.0, 0.0, 0.0, 0.0 );
                        }
                    }
                    else
                    {
                        gl_FragColor = v_fragmentColor;
                    }
                }
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_rich_string_color',              -- 颜色富文本
        vertex_shader = [[
            attribute vec4 a_position;
            attribute vec2 a_texCoord;
            attribute vec4 a_color;
            attribute vec4 a_color2;

            #ifdef GL_ES
            varying lowp vec4 v_fragmentColor;
            varying mediump vec2 v_texCoord;
            varying mediump vec4 v_fragmentColor2;
            #else
            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            varying vec4 v_fragmentColor2;
            #endif

            void main()
            {
                gl_Position = CC_MVPMatrix * a_position;
                v_fragmentColor = a_color;
                v_texCoord = a_texCoord;
                v_fragmentColor2 = a_color2;
            }
        ]],
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            varying vec4 v_fragmentColor2;
            uniform sampler2D CC_Texture0;
            uniform sampler2D CC_Texture1;

            void main()
            {
                vec4 color_0 = texture2D( CC_Texture0, v_texCoord );
                vec4 color_1 = texture2D( CC_Texture1, v_fragmentColor2.xy );
                if( v_fragmentColor2.z < 0.5 && color_0.a > 0.0 && color_0.a < 1.0 )
                {
                    //color_0.rgb = v_fragmentColor.rgb;
                    color_0.r = 1.0;
                    color_0.g = 1.0;
                    color_0.b = 1.0;
                }
                gl_FragColor = v_fragmentColor * color_0 * vec4( color_1.r, color_1.g, color_1.b, 1.0 );
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
            { name = 'a_color2', index = kCCVertexAttrib_Color_2, },
        },
    },
    {
        shader_name = 'position_texture_color_outer_glow',              -- 外发光
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;

            void main()
            {
                vec4 color = v_fragmentColor * texture2D( CC_Texture0, v_texCoord );

                float param = CC_Custom.a;
                float r = ( ( CC_Custom.r * param ) * ( 1.0 - color.a ) + color.r ) * color.a;
                float g = ( ( CC_Custom.g * param ) * ( 1.0 - color.a ) + color.g ) * color.a;
                float b = ( ( CC_Custom.b * param ) * ( 1.0 - color.a ) + color.b ) * color.a;

                gl_FragColor = vec4( r, g, b, color.a );
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_overlay',                     -- PS 中的叠加模式 : B <= 0.5: C=2*A*B; B > 0.5: C=1-2*(1-A)*(1-B)
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;

            void main()
            {
                vec4 tex_color = texture2D( CC_Texture0, v_texCoord );
                float a = tex_color.a * v_fragmentColor.a;
                float f = 0.3 * tex_color.r + 0.6 * tex_color.g + 0.1 * tex_color.b;

                if( f <= 0.5 )
                {
                    gl_FragColor.rgb = 2.0 * f * v_fragmentColor.rgb;
                }
                else
                {
                    gl_FragColor.rgb = 1.0 - 2.0 * ( 1.0 - f ) * ( 1.0 - v_fragmentColor.rgb );
                }

                gl_FragColor.rgb = gl_FragColor.rgb * a;
                gl_FragColor.a = a;

                //vec4 tex_color = texture2D( CC_Texture0, v_texCoord ) * v_fragmentColor;
                //float f = 0.3 * tex_color.r + 0.6 * tex_color.g + 0.1 * tex_color.b;

                //if( f <= 0.5 )
                //{
                //    gl_FragColor.rgb = 2.0 * f * CC_Custom.rgb;
                //}
                //else
                //{
                //    gl_FragColor.rgb = 1.0 - 2.0 * ( 1.0 - f ) * ( 1.0 - CC_Custom.rgb );
                //}

                //gl_FragColor.a = tex_color.a;
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_overlay_ex',                     -- PS 中的叠加模式 : B <= 0.5: C=2*A*B; B > 0.5: C=1-2*(1-A)*(1-B)
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;
            uniform vec4 CC_Custom_Ex;

            void main()
            {
                vec4 tex_color = texture2D( CC_Texture0, v_texCoord ) * v_fragmentColor;
                float f = 0.3 * tex_color.r + 0.6 * tex_color.g + 0.1 * tex_color.b;

                // 根据美术的需求，这个叠加的颜色，可能有个线性渐变的过程，从上而下的渐变
                // 其中 CC_Custom.a 是顶部的纹理坐标 v，CC_Custom_Ex.a 是底部的纹理坐标 v 
                // CC_Custom.rgb 就是顶部渐变颜色，CC_Custom_Ex.rgb 就是底部渐变颜色
                float temp = ( v_texCoord.y - CC_Custom.a ) / ( CC_Custom_Ex.a - CC_Custom.a );
                vec4 temp_color = vec4( CC_Custom.rgb * temp + CC_Custom_Ex.rgb * ( 1.0 - temp ), 1.0 );

                if( f <= 0.5 )
                {
                    gl_FragColor.rgb = 2.0 * f * temp_color.rgb;
                }
                else
                {
                    gl_FragColor.rgb = 1.0 - 2.0 * ( 1.0 - f ) * ( 1.0 - temp_color.rgb );
                }

                gl_FragColor.a = tex_color.a;
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_glare',                     -- PS 中的强光模式 : A <= 0.5 : C = 2 * A * B;  A > 0.5: C = 1 - 2 * ( 1 - A ) * ( 1 - B )
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;

            void main()
            {
                vec4 tex_color = texture2D( CC_Texture0, v_texCoord ) * v_fragmentColor;
                float f = 0.3 * tex_color.r + 0.6 * tex_color.g + 0.1 * tex_color.b;
                float f_a = 0.3 * CC_Custom.r + 0.6 * CC_Custom.g + 0.1 * CC_Custom.b;

                if( f_a <= 0.5 )
                {
                    gl_FragColor.rgb = 2.0 * f * CC_Custom.rgb;
                }
                else
                {
                    gl_FragColor.rgb = 1.0 - 2.0 * ( 1.0 - f ) * ( 1.0 - CC_Custom.rgb );
                }

                gl_FragColor.a = tex_color.a;
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
    {
        shader_name = 'position_texture_color_mv_ctrl',
        vertex_shader = vertex_shader_position_texture_color,
        fragment_shader = [[
            #ifdef GL_ES
            precision highp float;
            #endif

            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
            uniform sampler2D CC_Texture0;
            uniform vec4 CC_Custom;

            void main()
            {
                vec4 tex_color = texture2D( CC_Texture0, v_texCoord ) * v_fragmentColor;

                gl_FragColor = tex_color;
            }
        ]],
        attributes = {
            { name = 'a_position', index = kCCVertexAttrib_Position, },
            { name = 'a_color', index = kCCVertexAttrib_Color, },
            { name = 'a_texCoord', index = kCCVertexAttrib_TexCoords, },
        },
    },
}

function initCustomShaders()
    for _,shader_info in pairs( custom_shaders ) do
        local p = CCGLProgram:create()
        p:initWithVertexShaderByteArray( shader_info.vertex_shader, shader_info.fragment_shader )

        for _,attrib in ipairs( shader_info.attributes ) do
            p:addAttribute( attrib.name, attrib.index )
        end

        p:link()
        p:updateUniforms()

        CCShaderCache:sharedShaderCache():addProgram( p, shader_info.shader_name )
    end
end

function reloadOpenGL()
    for _,shader_info in pairs( custom_shaders ) do
        local p = CCShaderCache:sharedShaderCache():programForKey( shader_info.shader_name )
        if p ~= nil then
            p:reset()
            p:initWithVertexShaderByteArray( shader_info.vertex_shader, shader_info.fragment_shader )

            for _,attrib in ipairs( shader_info.attributes ) do
                p:addAttribute( attrib.name, attrib.index )
            end

            p:link()
            p:updateUniforms()
        end
    end

    TLFontTex:sharedTLFontTex():initFontTexture( GameSettings.color_tex_file, GameSettings.color_tex_row, GameSettings.color_tex_col, GameSettings.color_shader )
end

CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(CCDirector:sharedDirector():getRunningScene(), reloadOpenGL, "event_come_to_foreground")

function updateReloadShaders()
    for _,shader_info in pairs( custom_shaders ) do
        local p = CCShaderCache:sharedShaderCache():programForKey( shader_info.shader_name )
        if p == nil then
            p = CCGLProgram:create()
            p:initWithVertexShaderByteArray( shader_info.vertex_shader, shader_info.fragment_shader )

            for _,attrib in ipairs( shader_info.attributes ) do
                p:addAttribute( attrib.name, attrib.index )
            end

            p:link()
            p:updateUniforms()

            CCShaderCache:sharedShaderCache():addProgram( p, shader_info.shader_name )
        end
    end
end
