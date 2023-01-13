// VersionData.h
// SPDX-License-Identifier: MIT

class CVersionData
{
private:
    // Disallow construction
    CVersionData();
public:
    WORD   wLength;
    WORD   wValueLength;
    WORD   wType;
    WCHAR  szKey[1];
    const WCHAR *Data() const
    {
        if (this)
        {
            const WCHAR *p = szKey + wcslen(szKey) + 1;
            return (const WCHAR *)((INT_PTR)p + 3 & ~3);
        }
        return 0;
    }
    const CVersionData *First() const
    {
        if (this)
        {
            return (const CVersionData *)((INT_PTR)Data() + wValueLength + 3 & ~3);
        }
        return 0;
    }
    const CVersionData *Next() const
    {
        if (this)
        {
            return (const CVersionData *)((INT_PTR)this + wLength + 3 & ~3);
        }
        return 0;
    }
    const CVersionData *Find(LPCWSTR lpszKey) const
    {
        const CVersionData *p = First();
        while (p < Next())
        {
            if (lpszKey == 0 || _wcsicmp(lpszKey, p->szKey) == 0)
                return p;
            p = p->Next();
        }
        return 0;
    }
    static const CVersionData *Load(HMODULE hModule = 0, LPCWSTR lpszRes = MAKEINTRESOURCEW(VS_VERSION_INFO))
    {
        if (HRSRC const hFindRes = FindResourceW(hModule, lpszRes, MAKEINTRESOURCEW(RT_VERSION)))
            if (HGLOBAL const hLoadRes = LoadResource(hModule, hFindRes))
                return static_cast<const CVersionData *>(LockResource(hLoadRes));
        return 0;
    }
};
