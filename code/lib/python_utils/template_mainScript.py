# -*- coding: utf-8 -*-
"""
template_mainScript.py
normal script with direct main function
Copyright (C) 2020 Yuichi Takeuchi
"""

# import libraries
'''
import numpy as np
import matplotlib as mpl
'''


# define functions and classes #########
def myfunc_a(x, y):
    '''
    Docstring for this function
    '''
    return x + y


# main script for execution
if __name__ == '__main__':
    x, y = 3, 5
    out = myfunc_a(x, y)
    print(out)
