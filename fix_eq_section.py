#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def fix_eq_section():
    # 读取文件
    with open('entry/src/main/ets/pages/Player.ets', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 查找EQ Settings部分
    eq_start = content.find('      // EQ Settings\n      Column() {')
    if eq_start == -1:
        print("未找到EQ Settings部分")
        return False
    
    # 查找EQ部分的结束
    # 我们需要找到匹配的'}'，但需要小心嵌套
    brace_count = 0
    eq_end = eq_start
    in_brace = False
    
    for i in range(eq_start, len(content)):
        if content[i] == '{':
            brace_count += 1
            in_brace = True
        elif content[i] == '}':
            brace_count -= 1
            if brace_count == 0 and in_brace:
                # 找到匹配的'}'
                # 继续查找直到找到包含'.width('100%')'的行
                for j in range(i, min(i+100, len(content))):
                    if ".width('100%')" in content[j:j+20]:
                        # 找到包含'.width('100%')'的行
                        # 查找该行的结束
                        line_end = content.find('\n', j)
                        if line_end != -1:
                            eq_end = line_end
                            break
                if eq_end == eq_start:
                    eq_end = i + 1
                break
    
    print(f"EQ部分开始位置: {eq_start}")
    print(f"EQ部分结束位置: {eq_end}")
    
    # 提取EQ部分
    eq_section = content[eq_start:eq_end]
    print(f"原始EQ部分:\n{eq_section}")
    
    # 新的EQ部分
    new_eq_section = '''      // EQ Settings
      Column() {
        // EQ Settings Button
        Button('EQ Settings', { type: ButtonType.Normal })
          .width('100%')
          .height(48)
          .backgroundColor('#F0F7FF')
          .fontColor('#0A59F7')
          .onClick(() => {
            // Navigate to EQ page
            router.pushUrl({
              url: 'pages/EQPage'
            })
          })
          .margin({ bottom: 12 })
      }
      .padding({ left: 16, right: 16 })
      .width('100%')'''
    
    # 替换
    new_content = content[:eq_start] + new_eq_section + content[eq_end:]
    
    # 写回文件
    with open('entry/src/main/ets/pages/Player.ets', 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("成功替换EQ部分")
    return True

if __name__ == '__main__':
    fix_eq_section()