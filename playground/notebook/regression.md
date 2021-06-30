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
using Statistics

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

このとき最尤推定法によって

$$
\theta_k = \bar{Y}_k \underset{\textrm{def}}{=} \frac{1}{|I_k|} \sum_{i\in I_k} Y_i
$$

と推定することができる. これは $X_i = d_{i_k}$, $Y_i = \theta_{i_k}  + Z$ だった時の尤度 $L$ が

$$
\begin{aligned}
L&= \prod_{i=1}^n \mathcal{N}(Y_i - \theta_{i_k}) \\
  &= \prod_{k=1}^K \prod_{i\in I_k} \mathcal{N}(Y_i - \theta_{k}) 
\end{aligned}
$$

と書けるため, 対数尤度の最大化を要請すると $\theta_{k}$ についての偏導関数が 0 となる　$\theta_k$ の値として　$\bar{Y}_k$ が出てくる.

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

```julia

```
