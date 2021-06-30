using Dash
using DashCoreComponents
using DashHtmlComponents
using Distributions
app = dash(
	external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]
	)
xrange = -5:0.1:5
yrange = 0.001:0.01:1
mgX = repeat(xrange, length(yrange))
mgY = repeat(yrange, length(xrange))
function mixture(c, μ)
	d0 = Normal(0, 1)
	d1 = Normal(μ, 1)
	x = -5:0.01:5
	figure=(
		data = [
			(x = x, y = c*pdf.(d1, x)+(1-c)*pdf.(d0, x))
		],
		layout=(title="model", yaxis=(range=[0,0.4],))
	)
	return figure
end
app.layout = html_div() do
    html_h1("Hello Dash"),
    html_div("Dash.jl: Julia interface for Dash"),
    dcc_graph(
        id = "coord",
        figure = (
            data = [
                (x = mgX, y = mgY, mode = "markers"),
            ],
            layout = (title = "Parameter Space",hovermode="closest"),
        ),
    ),
    dcc_graph(id="gaussian-mixture", figure=mixture(0.5, 1))
end
callback!(
	app,
	Output("gaussian-mixture", "figure"),
	Input("coord","hoverData")
) do hoverData
	@show hoverData
	@show hoverData |> typeof
	if isnothing(hoverData)
		return mixture(0.5,1)
	else
		μ = hoverData.points[begin].x
		c = hoverData.points[begin].y
		return mixture(c, μ)
	end
end
run_server(app, "127.0.0.1", 8050, debug = true) # localhost:8050 にアクセス