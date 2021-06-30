---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.3
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

# 回帰問題

```julia
using Distributions
using LazySets
using Optim
using Plots
```

- ここでは $(X_i, Y_i), i = 1,2,\dots,n$ が サンプルとして与えられており, $X_i$ は有限集合 $D=\{d_1, d_2,\dots d_K\}\subset \mathbb{R}$ の要素からどれかを選ぶ確率変数で， $Y_i$ は $X_i$ が取る値で振る舞いが変化する条件付き確率 $p(Y_i | X_i)$ に従う確率変数だとする. 

- 条件付き確率 $p(Y_i | X_i)$ は次の設定のもとで特徴づけられていると確率モデルとする. $X_i$ が実現値として $d_{i_k} \in D$ を持つときに　$\theta_{i_k} = E[Y_i | X_i = d_{i_k}]$ をパラメータとして持っている確率モデルである. さらに $Y_i$ には標準正規分布 $Z$ に従うノイズが付与されているものとする． これらの条件は数式で書くと $(X_i, Y_i)$ は次のような確率モデルに従っているものと見ることができる:

$$
\begin{aligned}
X_i &= d_{i_k} , \\
Y_i &= \theta_{i_k}  + Z , \\
Z   &\sim \mathcal{N}(0, 1).
\end{aligned}
$$


# モデルの定式化

struct を用いて構造化しそれを使うことにする.

```julia
module My

struct Model
    n::Int # num of data
    D
    𝛉
end

function Base.rand(m::Model)
    K = length(m.D)
    k = rand(1:K)
    θ = m.𝛉[k]
    X = m.D[k]
    Y = θ + randn()
    return (k, X, Y)
end

end
```

```julia
# このようにすることで Model の中身を更新しても古いものを replace するだけなのでエラーが起きない.
using .My
Model = My.Model
```

# モデルの可視化

- ひとまずイメージを掴むために　$D$ や $\theta = (\theta_1, \theta_2, \dots, \theta_K)$ を与えてそこから得られるデータ $(X, Y)$ を可視化する.

```julia
n =100
D = collect(0.1:0.1:1)
𝛉 = rand(length(D)); # \bftheta
model = Model(n, D, 𝛉);
```

```julia
p = plot()
for i in 1:n
    _, X, Y = rand(model)
    scatter!(p, (X, Y), label=false)
end

plot!(D, 𝛉, label="\$\\theta\$")
display(p)
```

# データからパラメータを推定

- 逆にサイズが $n$ のサンプル $(X_i, Y_i), (i=1,2\dots, n)$ から上記で与えた確率モデルのパラメータを推定することを考える: $k = 1, \dots, K$ に対して　$X_i = d_k$ となる $i$ の集合を $I_k$ と置く:

$$
I_k  = \left\{i\in \{1,\dots, n\}; X_i = k\right\}.
$$

このとき最尤推定法によって　$\theta_k$ の推定量として

$$
\theta_k = \bar{Y}_k \underset{\textrm{def}}{=} \frac{1}{|I_k|} \sum_{i\in I_k} Y_i
$$

を得ることができる. これは $X_i = d_{i_k}$, $Y_i = \theta_{i_k}  + Z$ だった時の尤度 $L$ が

$$
\begin{aligned}
L&= \prod_{i=1}^n \mathcal{N}(Y_i - \theta_{i_k}) \\
  &= \prod_{k=1}^K \prod_{i\in I_k} \mathcal{N}(Y_i - \theta_{k}) 
\end{aligned}
$$

と書けるため, 対数尤度の最大化を要請すると $\theta_{k}$ についての偏導関数が 0 となる　$\theta_k$ の値として　$\bar{Y}_k$ が出てくる.
ここで $\mathcal{N}$ は標準正規分布に対応する密度関数である.

```julia
n =100000
D = collect(0.1:0.1:1)
𝛉 = rand(length(D)); # \bftheta
model = Model(n, D, 𝛉);
display(𝛉)
```

```julia
D = Dict((k, []) for k in 1:length(model.D))
for i in 1:n
    k, X, Y = rand(model)
    push!(D[k], (X=X, Y=Y))
end
```

```julia
𝛉_mle = [mean(getproperty.(D[k], :Y)) for k ∈ 1:length(model.D)]
𝛉_mle
```

```julia
hcat(𝛉, 𝛉_mle) # 各行に対して値が似ていること
```

# 増大モデル

$\theta_{i_k} = E[Y_i | X_i = d_{i_k}]$ 　で与えられるパラメータが 

$$
\theta_1\leq \theta_2 \leq \dots \leq \theta_K
$$

という単調非減少列の関係を満たすとする.

$K=2$ (すなわちパラメータの個数が 2 のとき)　は $\theta_1, \theta_2$ は次の青色の範囲を動く:

```julia
function create_domain(;ymax=2.)
    hs1 = HalfSpace([1., -1.], 0.)
    hs2 = HalfSpace([-1., 0.], 0.)
    hs3 = HalfSpace([0., -1.], 0.)
    hs4 = HalfSpace([0., 1.], ymax)
    #= for debugging
    p = plot(aspect_ratio=:equal, xlim=[-1, 1])
    plot!(p, hs1, color=:red)
    plot!(p, hs2, color=:blue)
    plot!(p, hs3, color=:green)
    =#
    domain = plot(
        xlim=[-1., 1.],　ylim=[-1., 1.],　
        aspect_ratio=:equal, xlabel="\$\\theta_1\$",  
        ylabel="\$\\theta_2\$"
    )
    ph = HPolyhedron([hs1, hs2, hs3, hs4])
    P_as_polytope = convert(HPolytope, ph);
    plot!(domain, P_as_polytope, color=:blue)
    domain
end
```

注意: 理論上は青色のゾーンは $\theta_2$ 方向に向かって無限に伸びているが領域の可視化における技術的な制限によって有界領域でしか描画ができない. `hs4` で　$\theta_2$ の上限を（とりあえず２）で抑えている.


# 青色ゾーンでの制約条件を課す確率モデル

確率モデルのパラメータに

$$
\theta_1\leq \theta_2 \leq \dots \leq \theta_K
$$

という制約と任意の $k$ に対して $|I_k| = r$ となる $r>0$ が存在するとする.　サイズ　$n$ のサンプル $(X_i, Y_i)$　が与えられているとしてそれから最尤推定でパラメータを推定する. いろんな計算をして

$$
\underset{\theta_1 \leq \theta_2 \leq \dots \leq \theta_K}{\textrm{min}} r \sum_{k=1}^K (Y_k  - \theta_k)^2
= \underset{\theta_1 \leq \theta_2 \leq \dots \leq \theta_K}{\textrm{min}} r \sum_{k=1}^K (\bar{Y}_k  - \theta_k)^2
$$

を満足する $\theta = (\theta_1,\dots, \theta_K)$ が求めたい値になることがわかる.


確率モデルは次のように単純化できる

```julia
𝛉 = (0.5, 1.0)
r = 300
sample1 = [(X=𝛉[1], Y=𝛉[1] + randn()) for _ in 1:r]
sample2 = [(X=𝛉[2], Y=𝛉[2] + randn()) for _ in 1:r];
```

```julia
Y_1 = mean(getproperty.(sample1, :Y))
Y_2 = mean(getproperty.(sample2, :Y))
domain = create_domain()
scatter!(domain, 𝛉, label="\$\\theta\$")
scatter!(domain, (Y_1, Y_2), label="\$\\bar{Y}\$")
```

- 真の分布 $\theta$ がこの領域の頂点 $(0, 0)$ にあるとする. (領域の境界) この状況で問題を解いてみる.

$$
\underset{\theta_1 \leq \theta_2 \leq \dots \leq \theta_K}{\textrm{min}} \dots
$$

となっている領域を矩形に変換する.


領域の境界に原点から伸びる軸を張って斜交座標 $(\eta_1, \eta_2)$ を用いて領域をパラメトライズし直す.
このとき領域は $(\theta_1, \theta_2) = (\eta_1, \eta_1 + \eta_2)$ $\eta_1\geq 0, \eta_2 \geq 0$　として得られる.

```julia
domain = create_domain()
u = Uniform(0, 2)
η₁ = rand(u, 100)
η₂ = rand(u, 100)
θ₁ = η₁
θ₂ = η₁ .+ η₂
scatter!((θ₁, θ₂), legend=false)
```

```julia
function f(η₁, η₂)
    θ₁ = η₁
    θ₂ = η₁ + η₂
    return (θ₁ - Y_1)^2 + (θ₂ - Y_2)^2
end

f(η) = f(η...)

𝛉 = (0., 0.)
r = 10
sample1 = [(X=𝛉[1], Y=𝛉[1] + randn()) for _ in 1:r]
sample2 = [(X=𝛉[2], Y=𝛉[2] + randn()) for _ in 1:r]

Y_1 = mean(getproperty.(sample1, :Y))
Y_2 = mean(getproperty.(sample2, :Y))
@show (Y_1, Y_2)
@show 𝛉
domain = create_domain(ymax=1.0)
scatter!(domain, 𝛉, label="\$\\theta\$", alpha=0.5)
scatter!(domain, (Y_1, Y_2), label="\$\\bar{Y}\$", alpha=1)
plot!(domain, x->-x, 0., 1., color=:orange, label=false)
lower = [0., 0.]
upper = [2., 2.]
initial_x = [1., 1.]
inner_optimizer = GradientDescent()
result = optimize(f, lower, upper, initial_x, Fminbox(inner_optimizer))
optη₁, optη₂ = result.minimizer
optθ₁, optθ₂ = optη₁, optη₁ + optη₂
@show (optθ₁, optθ₂)
scatter!(domain, (optθ₁, optθ₂), label="miniizer", alpha=0.8, color=:red, legend=:outertopleft)
```
