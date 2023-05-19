<script>
    /*
    * Connect2ic provides essential utilities for IC app development
    */
    import { createClient } from "@connect2ic/core"
    import { defaultProviders } from "@connect2ic/core/providers"
    import { ConnectButton, ConnectDialog, Connect2ICProvider } from "@connect2ic/svelte"
    import Wall from "./components/Wall.svelte";
    import "@connect2ic/core/style.css";
    import SideButton from "./components/SideButton.svelte";
    /*
    * Import canister definitions like this:
    */
    import * as studentwall from "../.dfx/local/canisters/studentwall"
    import * as wallcoin from "../.dfx/local/canisters/wallcoin"
 

    const client = createClient({
        canisters: {
            studentwall,
            wallcoin
        },
        providers: defaultProviders,
        globalProviderConfig: {
            dev: import.meta.env.DEV,
        },
    });


    </script>

    <Connect2ICProvider client={client}>
    <div class="App">
        <Wall />
        <div class="auth-section">
            <SideButton />
            <ConnectButton />
        </div>
        
        <ConnectDialog />
    </div>    

    </Connect2ICProvider>

    <style global>
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
        "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
        sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        color:darkred;
        background-color:lightskyblue;
    }

    button {
        font-weight: 600;
    }

    .slogan {
        font-size: 1.7em;
        margin-bottom: 0;
    }

    .twitter {
        font-size: 0.4em;
    }

    .App-logo {
        height: 14vmin;
        pointer-events: none;
        transform: scale(1);
        animation: pulse 3s infinite;
    }

    .App-header {
        height: calc(100vh - 70px);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        font-size: calc(10px + 2vmin);
    }


    .example {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .example-disabled {
        font-size: 1.3em;
        color: #9e9e9e;
    }

    .demo-button {
        background: #a02480;
        padding: 0 1.3em;
        margin-top: 1em;
        border-radius: 60px;
        font-size: 0.7em;
        height: 35px;
        outline: 0;
        border: 0;
        cursor: pointer;
        color: white;
    }

    .demo-button:active {
        color: white;
        background: #979799;
    }

    .auth-section {
        padding: 1em;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        text-align: right;
        position: fixed;
        top: 0;
        right: 0;
    }

    @keyframes pulse {
        0% {
            transform: scale(0.97);
            opacity: 0;
        }

        70% {
            transform: scale(1);
            opacity: 1;
        }

        100% {
            transform: scale(0.97);
            opacity: 0;
        }
    }
    </style>
