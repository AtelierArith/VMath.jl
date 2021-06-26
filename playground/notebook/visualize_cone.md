---
jupyter:
  jupytext:
    formats: ipynb,md
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

# 特異モデル

```julia
using LinearAlgebra
using Plots
using SymPy
```

```julia
plotly()
```

行列 $A$ をランク (階数) が 1 以下の実対称 $2\times 2$ 行列とする. このとき適当な直交行列 $P$ と $\lambda\in\mathbb{R}$を用いて

$$
A = P \begin{bmatrix} \lambda && 0 \\ 0 && 0 \end{bmatrix} P^\top
$$

と表示できる. もっと言えば

$$
P = 
\begin{bmatrix}
\xi_1 && \eta_1 \\
\xi_2 && \eta_2
\end{bmatrix}
$$

とおけば

$$
\begin{aligned}
A &= P \begin{bmatrix} \lambda && 0 \\ 0 && 0 \end{bmatrix} P^\top \\
  &= \lambda \begin{bmatrix} \xi_1^2 && \xi_1\xi_2 \\ \xi_2\xi_1 && \xi_2^2 \end{bmatrix} \\
  &= \lambda \begin{bmatrix} \xi_1 \\ \xi_2 \end{bmatrix} \begin{bmatrix} \xi_1 & \xi_2 \end{bmatrix} \\
  &= \lambda \vec{\xi} \vec{\xi}^\top
\end{aligned}
$$

と変形できる. $\vec{\xi}=[\xi_1, \xi_2]^\top$ は直交行列 $P$ を構成する縦ベクトルであるから

$$
\xi_1^2 + \xi_2^2 = 1
$$

を満たす. ところでこの行列 $A$ は $2\times 2$ の正方行列であるため, $A$ は $\det A = 0$ となる行列としても特徴付けられる.
従って $2\times 2$ 対称かつ非正則行列全体

$$
\Omega = 
\left\{
\begin{bmatrix}
a && b \\
b && c
\end{bmatrix}
\ 
;
\
ac - b^2 = 0
\right\}
$$

を $\lambda \in \mathbb{R}$ と $\xi_1 = \cos t, \xi_2 = \sin t$ という $t\in[0, 2\pi)$ でパラメトライズしていることになる.

```julia
@vars ξ_1 ξ_2 real=true
@vars η_1 η_2 real=true
@vars λ real=true
P = [
    ξ_1 η_1
    ξ_2 η_2
]
```

```julia
ᵗ(M) = transpose(M) # 転置行列のつもり
```

```julia
diag(λ, 0) # 対角行列
```

```julia
P * diag(λ, 0) * ᵗ(P)
```

```julia
λ * [ξ_1, ξ_2] * [ξ_1 ξ_2]
```

# $\Omega$ は錐 (cone) であることを確かめる.

```julia
ξ₁(t) = cos(t)
ξ₂(t) = sin(t)
```

```julia
w(t, λ=1) = λ .* [ξ₁(t), ξ₂(t)] * [ξ₁(t) ξ₂(t)]
```

```julia
w(Sym("t"))
```

```julia
det(w(Sym("t"))) # これは 0 になる.
```

```julia
x(t, λ) = w(t, λ)[1, 1]
y(t, λ) = w(t, λ)[1, 2]
z(t, λ) = w(t, λ)[2, 2]
```

```julia
trange = 0:0.01:2π
p = plot(legend=false)
for λ in -1:0.05:1
    plot!(p, 
        [x(t, λ) for t in trange], 
        [y(t, λ) for t in trange], 
        [z(t, λ) for t in trange]
    )
end
p
```

```julia
trange = 0:0.01:2π
λrange = -1:0.05:1
p = plot(legend=false)
for λ in λrange
    plot!(p, 
        [cos(t) for t in trange], 
        [sin(t) for t in trange], 
        repeat([λ], length(trange)),
    )
end
p
```

# $ac - b^2 = 0$ を変形して理解する

直感的に言えば $b$ の値を一つ固定し $a$ 軸と $c$ 軸からなる平面での $ac = b^2$ 反比例のグラフを描画することを想像すれば良い.

```julia
p = plot(aspect_ratio=:equal, xlim=[-2, 2], ylim=[-2, 2], legend=false, xlabel="a", ylabel="c")
for b₀ in 0.1:0.1:1
    plot!(a -> b₀/a, 0.01, 2, color=:red)
    plot!(a -> b₀/a, -2, -0.01, color=:red)
end
p
```

次のような座標変換をおこなう.

$$
\begin{bmatrix} a \\ c \end{bmatrix}
=
\frac{1}{\sqrt{2}}
\begin{bmatrix}
1 && 1 \\
-1 && 1
\end{bmatrix}
\begin{bmatrix} A \\ C \end{bmatrix}
$$

この時 $ac = b^2$ は $(A+C)(-A+C)/2 = b^2$ を経由して

$$
B^2 + A^2 - C^2 = 0
$$

という式になる. ここで $B^2 = 2b^2$ おいた. あとは [Wikipedia 円錐](https://ja.wikipedia.org/wiki/%E5%86%86%E9%8C%90) の項目を参照.
