load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("encoding/json.star", "json")
load("schema.star", "schema")
load("cache.star", "cache")
load("humanize.star", "humanize")
load("time.star", "time")


DEFAULT_TIMEZONE = "Pacific/Auckland"

ROCKETLAUNCH_API_URL = "https://fdo.rocketlaunch.live/json/launches/next/5"

CK_NAME = "next_name"
CK_PROVIDER = "next_provider"
CK_VEHICLE = "next_vehicle"
CK_DATE = "next_date"
CK_TIME = "next_time"
CK_PAD = "next_pad"
CK_LOCATION = "next_location"
CK_DESCRIPTION = "next_description"
CK_WEATHER = "next_weather"

FONT_TITLE = "6x13"
FONT_DETAIL = "tom-thumb"

COLOR_TITLE = "#eb1c23"
COLOR_DETAIL = "#008752"

# time formats
H12 = ("3:04", "3_04")
H24 = ("15:04", "15_04")

# rocket_icon = base64.decode("""
# iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAACY0lEQVQ4jY3P30tTYRzH8c/zPMdtHd2Za95oGYUU4Q+IIpk/iiSCsKSIFBOCAqM/oG6DcyXRXRdedhHFDOtuhRd5kaz9EEQpZ0RQ/kCRULd5zna2s/k8Txe1FXNi39svrzffL8F/zsPRUJ9SpdyglJ4SQjQIIWukkITsB3VdUutQLKA6q3qPNTW4NU2Fw1UFSik+TM6llf1wrj4WqNXUqx3drdWM0dLONCwQkL0Dui6p3RAb83jUK/4/eOxNFADBrZt+5HJ5UEZX6V44Vx8LuP/BxSGQAADDsKTgfJYAQL8+7rAL7keM0iNC7kRONnov19ZWXyrHxeFcYGpyzsykswOkXx93cK69c7vdnT7fQVXYKV7nVUnX+VZafnYRRz7GLdOwgo/vdQwqdr7mOVPIhabjTQrPbMFRrbLO7hZUOptzgWg4bpmmFXSt+YcAgJ24ODhFOXPSgtHu0Ry0q7sFTGEl3NbciNbmxhI2DCvoWvUP6ToRv+MAHoyGzxIqp7vOtRFfnVbx52gonkmZ1lt17S8GAAoAi+vG/URa2NORL0gl07twJDQvU0bmfTkuBZw8f13zeJ01dYcRCcVLEc4FYuEFbCQt8W15e6IcAwCN9fT0Dn8dO5BaWySJhIFiZGtzG9HwArIFBuLwMsqYf9dvACh1uYZbTh9Vn9w1kVj5jo3NlNwwCnY4tCBX15NcUX3YSiSyAF+pGIAQZ2ALiBfzuD0fsH4u/UgkU5mXfEe2r29mn87NftoxTTPCqDlSKaAIIZzLM5+XiZQzaqHw7NXItYnisk8PLhGb1judmTuv9YF8pcAvJgMvFQ4bgRAAAAAASUVORK5CYII=
# """)

# rocket_icon_b = base64.decode("""
# iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAACY0lEQVQ4jY3P30tTYRzH8c/zPMdtHd2Za95oGYUU4Q+IIpk/iiSCsKSIFBOCAqM/oG6DcyXRXRdedhHFDOtuhRd5kaz9EEQpZ0RQ/kCRULd5zna2s/k8Txe1FXNi39svrzffL8F/zsPRUJ9SpdyglJ4SQjQIIWukkITsB3VdUutQLKA6q3qPNTW4NU2Fw1UFSik+TM6llf1wrj4WqNXUqx3drdWM0dLONCwQkL0Dui6p3RAb83jUK/4/eOxNFADBrZt+5HJ5UEZX6V44Vx8LuP/BxSGQAADDsKTgfJYAQL8+7rAL7keM0iNC7kRONnov19ZWXyrHxeFcYGpyzsykswOkXx93cK69c7vdnT7fQVXYKV7nVUnX+VZafnYRRz7GLdOwgo/vdQwqdr7mOVPIhabjTQrPbMFRrbLO7hZUOptzgWg4bpmmFXSt+YcAgJ24ODhFOXPSgtHu0Ry0q7sFTGEl3NbciNbmxhI2DCvoWvUP6ToRv+MAHoyGzxIqp7vOtRFfnVbx52gonkmZ1lt17S8GAAoAi+vG/URa2NORL0gl07twJDQvU0bmfTkuBZw8f13zeJ01dYcRCcVLEc4FYuEFbCQt8W15e6IcAwCN9fT0Dn8dO5BaWySJhIFiZGtzG9HwArIFBuLwMsqYf9dvACh1uYZbTh9Vn9w1kVj5jo3NlNwwCnY4tCBX15NcUX3YSiSyAF+pGIAQZ2ALiBfzuD0fsH4u/UgkU5mXfEe2r29mn87NftoxTTPCqDlSKaAIIZzLM5+XiZQzaqHw7NXItYnisk8PLhGb1judmTuv9YF8pcAvJgMvFQ4bgRAAAAAASUVORK5CYII=
# """)

# rocket_icon_c = base64.decode("""
# iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gMRDhkvmYOhXgAAAmFJREFUOMuN0l1Ik1Ecx/HfOedxW49uc203WQYhRfgCRaTzpUgiCEuISDEhKDC66a5ug+cqorsCL7sIQsG6WyGRiLL2IoQSzoigTFEs1GePz7M989k853RRW7HWy//2z+d7zoFD8J9zezjaq1QpFymlR4QQdULIGikkIf+CmiapvTc5orqreg401Hl9PhUuTxUopZiamMso/8Lbe5IjtT71fHtXczVjtLSzTBsE5M8BTZPUqUuO+v3qufAPPPosAYDg8qUwtrfzoIyu0L+d7P0FF4dAAgBM05aC81kCAH3amMspeO8wSvcLuRM/XB84W1tbfaYcF4dzgemJOSubyfWTPm3Mxbnvhdfr7QgGd6vCMXgooJLOk820/NpFHH+dsi3Tjty73j6gOPmax0whpxoONig8uwlXtco6uppQ6dqcCyRiKduy7IhnNTwIAOzQ6YFpypmbFsxWv89FO7uawBRWwi2N9WhurC9h07QjnpXwoKYR8T0O4NZw7DihcqbzRAsJhnwV35yIprKGZT9XV39iAKAAsLhm3tAzwpmJv4ORzvyG49F5aZjZV+W4FHDz/AWfP+CuCe1DPJoqRTgXSMYWsJ62xYelrfFyDAA02d3dM/R+dJexukh03UQxsrmxhURsAbkCA3EFGGUsXOnPUOrxDDVNvVTvX7OgL3/E+oYh182CE4suyJW1NFfUIDZ1PQfw5YoBCHEMAMTRm7gyP2J//fxJTxvZJ3xHtq5t5B7Mzb7dsSwrzqh1t1KAfAkE5FJb2xKR8g0vFB61T06OF5e9WiREHPrQ7c5efar15ysFvgFRBSwZaopWfwAAAABJRU5ErkJggg==
# """)

# rocket_icon_d = base64.decode("""
# iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gMRDhs0IdAKMAAAAmRJREFUOMuN0k1IFGEcx/Hf8zyzs9vozrrtXjQNQorwBboo60uRRBCWEJFinQoMu9c1GOgSHQMPHTp00dA6bSWRiLbui5c8tEoEIcmKxrrrOrMz6+z2PNOhdotty/7Xh8/3+T/wEPzn3J2IDEku6Qql9JQQokkIp94RDiEHQU1zqHUkMam4XYPHWpu8qqpA9rhAKcXC3EpeOgjvNyYmG1TlUk9/Rx1jtHJm6BYIyN8DmuZQuykx5fMpF0M/8dTzOACCa1dD2N8vgjKaov+62fsbLg+BAwDQdcsRnL8nADCsTct2yXuPUXpUON9iJ1v8Fxoa6s5X4/JwLrA4t2KY+cIIGdamZc7VV16vtzcQOKwIO8eDfoX0nemg1WuXcWwpaRm6FX5wq2dUsov1T5lEzrYeb5W4mYFcp7De/nbUWptzgXg0aRmGFfZshq4DADtxbnSRcuamJb3bp8q0r78dTGIV3NnWgo62lgrWdSvsSYWuaxoRP+IA7kxEuwh1lvtOd5JAUK355ngkaeYM66Wy+QsDAAWA9S19PJsX9nJsDbnd/B84Fvng5HTzbTWuBNy8eFn1+d31wWbEIslKhHOBRHQV6V1LfPqyN1uNAYAmBgYGxz5OHcptrpNsVkc5ktnZQzy6ikKJgch+RhkL1fozlHo8Y+0Lb5SHNw1kNz4jvZNz0nrJjkZWndTWLpeUADLZbAHgG7UC7H4m8wwAnMev0agUrHeuZsO0xbSqyOOptGVub33tKhbtJYkat9cWZnh1gGz7/Q4AbHR3v+Cl0pOe+fnZ8uGQFg4Smz5yu80bM9pIsdYG3wFGIiiy+bwJ8gAAAABJRU5ErkJggg==
# """)

# rocket_icon_e = base64.decode("""
# iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gMRDhwXzPbthQAAAlpJREFUOMuNk81LVFEYh3/nnOvMdHXuOI0bLaOQIvyAWiTjR5FEEJYUoWJCUFC0aVfb4K4k2rXwDwhCw9pNIpELZZoPN2o4RgSliSLleOd678yduTOec1vUTDVN2W91Di/Pc94X3kPwn7k/Gu6TqqSrlNITQogGIZwaRziE7AWqqkOtA/Ex2V3Ve6SpwasoMlyeKlBKMTO9kJb2gnP18bFaRb7U0d1azRgt1UzDAgH5u0BVHWo3xMd9Pvli8Ac8/iIGgOBafxC5XB6U0XX6r5e9v8DFEDgAAMOwHMH5PAGAAXXCZRe8Dxilh4SzGz3e6L9QW1t9vhwuhnOB2ekFM5PODpIBdcLFuTLp9Xo7A4H9srB1XueXSdeZVlredhGOvklYpmGFHt7uGJLsfM0TJpGzTUebJJ7ZhqtaZp3dLajUNucCsUjCMk0r5NkIDgMAO3ZuaJZy5qYFo92nuGhXdwuYxEpwW3MjWpsbS7BhWCHPenBYVYn4LgdwbzRyilBnrut0GwnUKRVnjoUTGd20XsobP2EAoACwsmnc0dLCnou+g55K/wFHw0uObmRel8MlgZvnryg+v7um7iCi4URJwrlAPLKMrZQlPnzemSqHAYDGe3p6b70f36dvrBBNM1CUbCd3EIssI1tgIC4/o4wFK+0MPby4ONky80p+dNOEtvYRW0nd2TIKdiS87KxvprgkB7CtaVmAr1UUFA/i5F1cXxqzvqx+0lJ65infddo3k9nHC/Nvd03TjDJqjlQS/PYX5J2v/c9GLk8V731qaJXYtN7tztx4rg7mKwm+AeP6I6z2tLb7AAAAAElFTkSuQmCC
# """)


def main(config):

    location = config.get("location")
    location = json.decode(location) if location else {}
    timezone = location.get("timezone", config.get("$tz", DEFAULT_TIMEZONE))

    launch_cached = cache.get(CK_NAME)
    if launch_cached != None:
        print("Hit! Displaying cached data.")
        launch = launch_cached
    else:
        print("Miss! Calling RocketLaunch.Live API.")
        rep = http.get(ROCKETLAUNCH_API_URL)
        if rep.status_code != 200:
            fail("RocketLaunch.Live request failed with status %d", rep.status_code)
        launch = rep.json()["result"][0]
        

        cache.set(CK_NAME, launch["name"], ttl_seconds = 240)
        cache.set(CK_PROVIDER, launch["provider"]["name"], ttl_seconds = 240)
        cache.set(CK_VEHICLE, launch["vehicle"]["name"], ttl_seconds = 240)
        cache.set(CK_DATE, launch["date_str"], ttl_seconds = 240)
        cache.set(CK_TIME, launch["win_open"], ttl_seconds = 240)
        cache.set(CK_PAD, launch["pad"]["name"], ttl_seconds = 240)
        cache.set(CK_LOCATION, launch["pad"]["location"]["name"], ttl_seconds = 240)
        cache.set(CK_DESCRIPTION, launch["launch_description"], ttl_seconds = 240)
        cache.set(CK_WEATHER, launch["weather_summary"], ttl_seconds = 240)


    when_time = time.parse_time(cache.get(CK_TIME), "2006-01-02T15:04Z").in_location(timezone);
    when = humanize.time_format("EEE MMM d HH:mm", when_time)

    return render.Root(
        child = render.Box(
            render.Column(
                expanded = True,
                main_align = "start",
                cross_align = "start",
                children = [
                    render.Row(
                        children = [
                            render.Text(cache.get(CK_PROVIDER), font = FONT_TITLE, color = COLOR_TITLE),
                            # render.Animation(
                            #     children = [
                            #         render.Image(src = rocket_icon),
                            #         render.Image(src = rocket_icon_b),
                            #         render.Image(src = rocket_icon_c),
                            #         render.Image(src = rocket_icon_d),
                            #         render.Image(src = rocket_icon_e),
                            #         render.Image(src = rocket_icon_d),
                            #         render.Image(src = rocket_icon_c),
                            #         render.Image(src = rocket_icon_b),
                            #         render.Image(src = rocket_icon),
                            #         render.Image(src = rocket_icon_d),
                            #         render.Image(src = rocket_icon_e),
                            #         render.Image(src = rocket_icon_d),
                            #         render.Image(src = rocket_icon),
                            #     ],
                            # )
                        ]
                    ),
                    render.Text(cache.get(CK_NAME), font = FONT_DETAIL, color = COLOR_DETAIL),
                    render.Text(when, font = FONT_DETAIL, color = COLOR_DETAIL),
                    render.Marquee(
                        width = 64,
                        child = render.Row(
                            children = [
                                render.Text(content = " Desc: ", font = FONT_DETAIL, color = COLOR_DETAIL),
                                render.Text(content = cache.get(CK_DESCRIPTION), font = FONT_DETAIL),
                                render.Text(content = " Vehicle: ", font = FONT_DETAIL, color = COLOR_DETAIL),
                                render.Text(content = cache.get(CK_VEHICLE), font = FONT_DETAIL),
                                render.Text(content = " Loc: ", font = FONT_DETAIL, color = COLOR_DETAIL),
                                render.Text(content = cache.get(CK_LOCATION), font = FONT_DETAIL),
                                render.Text(content = " Pad: ", font = FONT_DETAIL, color = COLOR_DETAIL),
                                render.Text(content = cache.get(CK_PAD), font = FONT_DETAIL),
                                render.Text(content = " Weather: ", font = FONT_DETAIL, color = COLOR_DETAIL),
                                render.Text(content = cache.get(CK_WEATHER), font = FONT_DETAIL),
                            ])
                    )
                ],
            ),
        ),
    )        


def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Location(
                id = "location",
                name = "Location",
                desc = "Location defining the timezone.",
                icon = "locationDot")
        ]
    )    