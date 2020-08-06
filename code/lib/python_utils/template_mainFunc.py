# -*- coding: utf-8 -*-
"""
template_mainFuc.py
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


def main():
    x, y = 3, 5
    out = myfunc_a(x, y)
    print(out)
    return out


# main procedure when called
if __name__ == '__main__':
    main()
