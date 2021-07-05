### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 04a8675c-c8d9-11eb-1d4d-57efc6e439ef
begin
	using Distributions
	using Plots
end	

# ╔═╡ 9143fdc5-b647-467b-97ca-c6bbb0d08b0b
using PlutoUI

# ╔═╡ a247acff-3e7a-4094-bfe5-905245681462
@bind θ Slider(-2:0.01:2)

# ╔═╡ 2b4f980c-1132-48fd-a17e-476fcc5c97c4
md"""
確率モデルは次のような分散共分散行列が（単位行列 $I_m$, 1次元だと1)である正規分布の族だとする. 対応する確率密度関数は次の通り:

```math
f(x| \theta) = \frac{1}{(2\pi)^{m/2}}\exp\left(\frac{1}{2}||x-\theta||^2\right)
\quad \textrm{for} \quad \theta \in \mathbb{R}^m
```
"""

# ╔═╡ a00f7006-a9ec-4f5c-80ce-6d766c297cf8
plot(x -> pdf(Normal(θ, 1), x))

# ╔═╡ 889abc18-b47b-4d50-97f1-30df504c1523
md"""
i.i.d なサンプル $X_1, X_2, \dots X_n$ を生成する真の分布 $q$ が上記の確率モデルに含まれていると仮定しする. i.e. $q = q(x) = f(x| \theta_0)$ for some $\theta_0$.
最尤推定法(maximul likehood estimation)によって尤度を最大化するパラメータの値最尤推定量(maximum likehood estimator) $\hat\theta$が得られる． 今回の例では次のように記述できる:

```math
\hat\theta_n = \frac{1}{n}\sum_{i=1}^n X_i
```
"""

# ╔═╡ 64a610d3-e8a5-4084-8614-c9788e9ec3e1
md"""
ここで $\hat\theta_n$ の右辺はサンプルによる標本平均になっている． これらはサンプルを取得する試行ごとに結果が異なってくる （数学的には確率変数） のため推定量はランダムに振る舞うことに注意.
$X_i$ は $N(\theta_0, I_m)$ に従うのでそれらの線形和である $\hat\theta$ は $N(\theta_0, \frac{1}{n}I_m)$ に従う. すなわち $\sqrt{n}(\hat\theta_n - \theta_0)$ は標準正規分布に従う.
"""

# ╔═╡ a71b299a-5ed3-4637-a921-b39019e00dac
@bind θ₀ Slider(-2:0.01:2)

# ╔═╡ ce322c0e-718e-4e54-acb7-d5f2e1976ab6
@bind n Slider(1000:50:100000)

# ╔═╡ 84092a6f-147a-46e0-980a-f523995f7892
begin
	d = Normal(θ₀, 1)
	Yₙ = Float64[]
	for t in 1:100 # 試行回数
		Xs = rand(d, n) # X₁,X₂,…,Xₙ 
		θ̂ₙ = mean(Xs)
		push!(Yₙ, √n .* (θ̂ₙ .- θ₀))
	end
	plot(title="sample $n", xlims=[-3,3], ylims=[0,0.5])
    histogram!(Yₙ, normalize=true, alpha=0.5, bins=20)
	plot!(x -> pdf(Normal(0, 1), x))
end

# ╔═╡ Cell order:
# ╠═04a8675c-c8d9-11eb-1d4d-57efc6e439ef
# ╠═9143fdc5-b647-467b-97ca-c6bbb0d08b0b
# ╠═a247acff-3e7a-4094-bfe5-905245681462
# ╟─2b4f980c-1132-48fd-a17e-476fcc5c97c4
# ╠═a00f7006-a9ec-4f5c-80ce-6d766c297cf8
# ╟─889abc18-b47b-4d50-97f1-30df504c1523
# ╟─64a610d3-e8a5-4084-8614-c9788e9ec3e1
# ╠═a71b299a-5ed3-4637-a921-b39019e00dac
# ╠═ce322c0e-718e-4e54-acb7-d5f2e1976ab6
# ╠═84092a6f-147a-46e0-980a-f523995f7892
