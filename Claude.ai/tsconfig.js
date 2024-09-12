// File: .vscodeignore
.vscode/**
.vscode-test/**
out/test/**
src/**
.gitignore
vsc-extension-quickstart.md
**/tsconfig.json
**/.eslintrc.json
**/*.map
**/*.ts

// File: .gitignore
out
node_modules
.vscode-test/
*.vsix

// File: tsconfig.json
{
    "compilerOptions": {
        "module": "commonjs",
        "target": "es6",
        "outDir": "out",
        "lib": [
            "es6"
        ],
        "sourceMap": true,
        "rootDir": "src",
        "strict": true
    },
    "exclude": [
        "node_modules",
        ".vscode-test"
    ]
}
