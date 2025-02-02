// This artifact will contain multiple files. I'll separate them with comments.

// File: package.json
{
  "name": "vscode-claude-extension",
  "displayName": "Claude AI Assistant",
  "description": "Integrate Claude AI into VSCode",
  "version": "0.0.1",
  "engines": {
    "vscode": "^1.60.0"
  },
  "categories": [
    "Other"
  ],
  "activationEvents": [
    "onCommand:vscode-claude-extension.queryClaude"
  ],
  "main": "./out/extension.js",
  "contributes": {
    "commands": [
      {
        "command": "vscode-claude-extension.queryClaude",
        "title": "Query Claude AI"
      }
    ],
    "configuration": {
      "title": "Claude AI Assistant",
      "properties": {
        "claudeAssistant.apiKey": {
          "type": "string",
          "default": "",
          "description": "API Key for Claude AI"
        }
      }
    }
  },
  "scripts": {
    "vscode:prepublish": "npm run compile",
    "compile": "tsc -p ./",
    "watch": "tsc -watch -p ./",
    "pretest": "npm run compile && npm run lint",
    "lint": "eslint src --ext ts",
    "test": "node ./out/test/runTest.js"
  },
  "devDependencies": {
    "@types/vscode": "^1.60.0",
    "@types/node": "14.x",
    "@typescript-eslint/eslint-plugin": "^4.26.0",
    "@typescript-eslint/parser": "^4.26.0",
    "eslint": "^7.27.0",
    "typescript": "^4.3.2"
  }
}

// File: src/extension.ts
import * as vscode from 'vscode';
import { queryClaude } from './claudeApi';

export function activate(context: vscode.ExtensionContext) {
    console.log('Claude AI Assistant is now active!');

    let disposable = vscode.commands.registerCommand('vscode-claude-extension.queryClaude', async () => {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const selection = editor.selection;
            const text = editor.document.getText(selection);

            if (text) {
                try {
                    const response = await queryClaude(text);
                    editor.edit(editBuilder => {
                        editBuilder.replace(selection, response);
                    });
                } catch (error) {
                    vscode.window.showErrorMessage('Error querying Claude: ' + error.message);
                }
            } else {
                vscode.window.showInformationMessage('Please select some text to query Claude.');
            }
        }
    });

    context.subscriptions.push(disposable);
}

export function deactivate() {}

// File: src/claudeApi.ts
import axios from 'axios';
import * as vscode from 'vscode';

const API_URL = 'https://api.anthropic.com/v1/messages';

export async function queryClaude(prompt: string): Promise<string> {
    const config = vscode.workspace.getConfiguration('claudeAssistant');
    const apiKey = config.get<string>('apiKey');

    if (!apiKey) {
        throw new Error('Claude API key is not set. Please set it in the extension settings.');
    }

    try {
        const response = await axios.post(API_URL, {
            messages: [{ role: 'user', content: prompt }],
            model: 'claude-3-opus-20240229',
            max_tokens: 1000
        }, {
            headers: {
                'Content-Type': 'application/json',
                'X-API-Key': apiKey
            }
        });

        return response.data.content[0].text;
    } catch (error) {
        console.error('Error querying Claude:', error);
        throw new Error('Failed to get response from Claude');
    }
}

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
