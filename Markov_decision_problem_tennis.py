# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.16.7
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# %%

import numpy as np
import scipy.optimize as opt

# %% [markdown]
# # GM: Experiments

# %% [markdown]
# ## Tennis problem

# %% [markdown]
# This gives the correct answer at the end.

# %%
p_ace = [[3/8, 5/8], [1,0]]
p_lob = [[7/8, 1/8], [1,0]]

# %%
p = np.array([p_ace, p_lob])

# %%
p

# %%
r = p.transpose([2,1,0]).reshape((2,4))
r

# %%
u = (np.eye(2)[:,:,np.newaxis] @ np.array([[1,1]])).reshape((2,4))
u

# %%
A_eq = np.concatenate([np.ones([1,4]), u - r])
A_eq

# %%
b_eq = np.zeros(3)
b_eq[0] = 1.0
b_eq


# %%
cm = np.array([[-1/8, 7/24], [1/2, 10/24]])
cv = cm.reshape((4,))
cv

# %%
lp_sol = opt.linprog(cv, A_eq = A_eq, b_eq = b_eq, bounds = (0,1))

# %%
lp_sol

# %%
