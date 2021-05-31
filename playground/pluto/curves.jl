### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ d3433ad2-c102-11eb-35d7-0fc2a33460fa
begin
	using LinearAlgebra
	
	using QuadGK
	using HCubature
	using Plots
	using Zygote
end

# ╔═╡ 2c031d00-02c6-4ab6-b782-c96eb4817759
md"""
# Julia による曲線と曲面の初等的な微分幾何
"""

# ╔═╡ 70efadc6-6453-48d5-95f1-bc1453b143bd
md"""

- パラメータ $t$ でパラメトライズされている二次元ユークリッド空間 $\mathbb{R}^2$ 上の滑らかな曲線 $p=p(t)$ において， その曲線に沿ってある点から別の点へ行くための移動距離を計算する方法をプログラミング言語 Julia で行う. $p(t) \in \mathbb{R}^2$ $x$ 及び $y$ 座標値は $t$ によって変化するから下記のように各々の座標を与える座標関数 $x=x(t)$, $y=y(t)$ を用いて次のように書くこともできる:

```math
p: \mathbb{R} \ni t \mapsto p(t) =
\begin{bmatrix}
x(t) 
\\
y(t)
\end{bmatrix} \in \mathbb{R}^2.
```

- 始点 $A = p(t)|_{t=a}$ から終点 $B = p(t)|_{t=b}$ へ曲線に沿って向かう移動距離は次のようにして定まる:

```math
\int_{a}^b \left|\dot{p}(\tilde{t})\right|\,d\tilde{t}
```

ここで $\dot{p}(\tilde{t})$ は $t=\tilde{t}$ での座標関数の導関数 $\dot{x}(t)|_{t=\tilde{t}}$, $\dot{y}(t)|_{t=\tilde{t}}$ の値を並べたものである:


```math
\dot{p}: \mathbb{R} \ni t \mapsto \dot{p}(t) =
\begin{bmatrix}
\dot{x}(t) 
\\
\dot{y}(t)
\end{bmatrix} \in \mathbb{R}^2.
```

また $\left|\dot{p}(t)\right|$ はベクトル $p(t)\in \mathbb{R}^2$ の長さを表す:

```math
\begin{aligned}
\left|\dot{p}({t})\right| 
&= \sqrt{(\dot{x}(t))^2 + (\dot{y}(t))^2} \\
&= \sqrt{\left(\frac{d x}{d t}(t)\right)^2 + \left(\frac{d y}{d t}(t)\right)^2}

\end{aligned}
```

このノートブックにおける，　時刻を表す $t$ についての関数 $x$ の上にドットをつけて導関数 $\frac{dx}{dt}$ を　$\dot{x}$ のように表す記法は物理学で用いられる慣習から来ている. $\dot{p}(t)$ は点 $p(t)$ での接線を意味する. 物理的には速度ベクトルを表す.
"""

# ╔═╡ 17301488-27c1-41e7-8a27-2a8a17da9283
md"""
# Example

- 半径　$r$　の円周は 

```math
p(t) 
= 
\begin{bmatrix}
x(t) \\ y(t)
\end{bmatrix} 
=
\begin{bmatrix}
r \cos t \\ r \sin t
\end{bmatrix}
\quad 
\textrm{for}
\
t \in [0, 2\pi]
```

と表示できる. また容易に $|\dot{p}(t)| = r$ がわかるので曲線　$p$ に沿った初期時刻 $t=0$ の地点からある $t$ の地点 $p(t)$ までの移動距離 $s$ は次のようにして得られる

```math
s = \int_{0}^{t} |\dot{p}(t)|\, dt = \int_{0}^t r\, dt = rt.
```
"""

# ╔═╡ b7380457-b9a9-442f-bb89-3633e3d01458
md"""
Julia で実装を行う. 曲線は $t$ を引数にするベクトル値関数と思えば良い.
"""

# ╔═╡ 428c1afa-6189-424a-b412-ff71d2f035f7
begin 
	r = 2.
	p(t) = [
		r * cos(t),
		r * sin(t)
	] # これは関数を定義する Julia の文法
end

# ╔═╡ 3782ff37-a844-482c-9fe4-e74c72706962
md"""
いわゆる接ベクトルを表す $\dot{p}(t)$ は(多変数写像のヤコビ行列の特別な形とみなして) `Zygote.jacobian` を用いて記述できる.　下記のコードで `jacobian(p, t)[begin]` とするのは欲しいデータがTupleで包まれているからである.
"""

# ╔═╡ dfbde3ef-5bb4-4fd0-acbd-41284f1c0582
ṗ(t) = jacobian(p, t)[begin] # squeeze

# ╔═╡ b6609761-33cf-4a71-bd0b-b88339790ee7
begin
	t_range = 0:0.5:2π
	plot(t->p(t)[1], t->p(t)[2], 0, 2π, aspect_ratio=:equal, legend=false)
	quiver!(
		[p(t)[1] for t in t_range], [p(t)[2] for t in t_range], 
		quiver=([ṗ(t)[1] for t in t_range], [ṗ(t)[2] for t in t_range])
	)	
end

# ╔═╡ ac038090-22e9-4af7-93bd-a5445a58759f
md"""
- 曲線の長さは次のようにして計算する:
"""

# ╔═╡ bda229a9-28d4-44ed-8976-f43f1bc4b05d
s(t) = quadgk(t̃->norm(ṗ(t̃)), 0, t)[begin]
#ss(t) = hcubature(t̃->norm(ṗ(t̃...)), [0], [t])[begin]

# ╔═╡ c4659009-a2fe-4add-a3a7-9d57ba13a309
begin 
	t = rand()
	isapprox(s(t),  r * (t))
end

# ╔═╡ Cell order:
# ╟─2c031d00-02c6-4ab6-b782-c96eb4817759
# ╠═d3433ad2-c102-11eb-35d7-0fc2a33460fa
# ╟─70efadc6-6453-48d5-95f1-bc1453b143bd
# ╟─17301488-27c1-41e7-8a27-2a8a17da9283
# ╠═b7380457-b9a9-442f-bb89-3633e3d01458
# ╠═428c1afa-6189-424a-b412-ff71d2f035f7
# ╟─3782ff37-a844-482c-9fe4-e74c72706962
# ╠═dfbde3ef-5bb4-4fd0-acbd-41284f1c0582
# ╠═b6609761-33cf-4a71-bd0b-b88339790ee7
# ╟─ac038090-22e9-4af7-93bd-a5445a58759f
# ╠═bda229a9-28d4-44ed-8976-f43f1bc4b05d
# ╠═c4659009-a2fe-4add-a3a7-9d57ba13a309
