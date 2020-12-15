# 目录

## Bootstrap图标网址

https://www.thinkcmf.com/font/font_awesome/icons.html

## Json对象数组多字段排序

```javascript
/*
 数组根据json对象数组中一个字段或者多个字段属性值进行排序的方法
 @param1: attr, 需要排序字段的数组，例如：['name','sex'...]
 @param2: rev, true表示升序排列，false降序排序,若参数不传递，默认表示升序排序 
 使用例子：newArray.sort(sortByArr(['number'],false))
*/
function sortByArr(arr, rev) {
  if (rev == undefined) {
    rev = 1;
  } else {
    rev = rev ? 1 : -1;
  }
  return function (a, b) {
    for (var i = 0; i < arr.length; i++) {
      let attr = arr[i];
      if (a[attr] != b[attr]) {
        if (a[attr] > b[attr]) {
          return rev * 1;
        } else {
          return rev * -1;
        }
      }
    }
  };
}
```