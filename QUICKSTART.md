# GitHub CLI Skills - 快速开始

## 第一步：生成 Token

1. 打开 https://github.com/settings/tokens/new
2. 输入 Note：`Claude Skills`
3. 勾选 4 个权限：
   - `repo`
   - `workflow`
   - `read:org`
   - `gist`
4. 点击底部 **Generate token**
5. 复制 Token（以 `ghp_` 开头）

## 第二步：发送 Token

直接对我说：

> 我的 GitHub Token 是：ghp_xxxxxxxxxxxx

**剩下的我来完成！**

---

配置完成后，试试：

```
/github-repo list
```

---

**安全说明**：Token 仅存储在本地 `.env` 文件，不会外泄。如需撤销，访问 https://github.com/settings/tokens
