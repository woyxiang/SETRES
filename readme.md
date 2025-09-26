# SETRES
![GitHub language count](https://img.shields.io/github/languages/count/woyxiang/setres) ![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/woyxiang/setres/build.yml) ![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/woyxiang/setres/latest/total) ![Scoop License](https://img.shields.io/scoop/l/SETRES?bucket=https%3A%2F%2Fgithub.com%2Fwoyxiang%2Fslug) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/woyxiang/setres)



## Installation
Download the latest [release](https://github.com/woyxiang/SETRES/releases)

Or install with [scoop](scoop.sh)

```
scoop bucket add slug https://github.com/woyxiang/slug
scoop install setres
```

## Useage

```
        SETRES h<XXXX> v<XXXX> [f<XX>] [b<XX>]
        SETRES f<XX> [b<XX>]

        h<XXXX> = Horizontal size of screen in pixels
        v<XXXX> = Vertical size of screen in pixels
          b<XX> = Bit (colour) depth such as 8, 16 24, 32
          f<XX> = Refresh frequncy in Hertz, e.g. 60, 75, 85

EXAMPLES
        SETRES h1024 v768
        SETRES h800 v600 b24
        SETRES h1280 v1024 b32 f75
        SETRES f75
```

## Compile

Download a freeBASIC compiler [here](http://sourceforge.net/project/fbc) 
or install with scoop `scoop install freebasic`

Clone this repo and then run
`fbc SETRES.bas lang.rc`

## Others

这个软件复刻自[Ian Sharpe](https://www.iansharpe.com/)的同名软件SETRES，用法几乎一样。之所以要自己写一个几乎一样的软件的直接原因是原版本不能单独修改刷新率，而我常常要单独修改它，所以就写了一个可以只传递f参数版本。

This tool is inspired by [Ian Sharpe](https://www.iansharpe.com/)'s SETRES. It offers nearly identical functionality but was written from scratch. The main motivation was to add the ability to change only the refresh rate (using the 'f' parameter only), a feature missing from the original.