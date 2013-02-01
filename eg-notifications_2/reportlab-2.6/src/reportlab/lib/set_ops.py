#!/bin/env python
#Copyright ReportLab Europe Ltd. 2000-2012
#see license.txt for license details
#history http://www.reportlab.co.uk/cgi-bin/viewcvs.cgi/public/reportlab/trunk/reportlab/lib/set_ops.py
__version__=''' $Id: set_ops.py 3959 2012-09-27 14:39:39Z robin $ '''
__doc__="""From before Python had a Set class..."""

import types
import string

def __set_coerce(t, S):
    if t is list:
        return list(S)
    elif t is tuple:
        return tuple(S)
    elif t is bytes:
        return string.join(S, '')
    return S

def unique(seq):
    result = []
    for i in seq:
        if i not in result:
            result.append(i)
    return __set_coerce(type(seq), result)

def intersect(seq1, seq2):
    result = []
    if type(seq1) != type(seq2) and type(seq2) == bytes: seq2 = list(seq2)
    for i in seq1:
        if i in seq2 and i not in result: result.append(i)
    return __set_coerce(type(seq1), result)

def union(seq1, seq2):
    if type(seq1) == type(seq2):
        return unique(seq1 + seq2)
    if type(seq1) == list or type(seq2) == list:
        return unique(list(seq1) + list(seq2))
    if type(seq1) == tuple or type(seq2) == tuple:
        return unique(tuple(seq1) + tuple(seq2))
    return unique(list(seq1) + list(seq2))
