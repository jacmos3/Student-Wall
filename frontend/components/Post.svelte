<script>
    import { useCanister,useTransfer,useWallet } from "@connect2ic/svelte";
    import Fa from 'svelte-fa/src/fa.svelte';
    import {onMount} from "svelte";
    import { faThumbsUp, faThumbsDown, faTrash, faHandHoldingDollar, faPenToSquare, faRotateRight} from '@fortawesome/free-solid-svg-icons'
    export let content; 
    export let creator; 
    export let vote;
    export let id;
    export let edited;
    let handle;
    
    let transfer;
    let editing = false;
    let updatedText;
    //avoid anonym users
    let disableTips = String(creator).length < 10;
    console.log(disableTips);

    const [wallet] = useWallet();

    const getHandle = async () => {
        return await $studentwall.getHandleT(String(creator));
    };
    onMount( async () => {
        handle = await getHandle();
        if (!handle.length)
            handle = null;
        console.log("Component mounted, creator:", String(creator), "with handle: ", handle);
    });

    const sendUpdatedMessage = async () => {
        console.log("sendUpdatedMessage: ", updatedText);
        let result = await $studentwall.updateTextMessage(id, updatedText);
        console.log(result);
        await refresh();
        editing = false;
    };
    
    const onTipping = async () => {
        try {
            console.log("trying");
            [transfer] = await useTransfer({
            to: String(creator),
            amount: Number(0.01),
            });
            const { height } = await transfer();
            console.log("blocco convalidato:", height);
        } catch (error) {
            console.log('Errore durante la transazione:', error);
        }   
    };

    const [studentwall] = useCanister("studentwall");
    
    const onEdit = async () => {
        console.log("onEdit: ",id, updatedText);
        updatedText = content.Text;
        editing = !editing;
    };

    const onDelete = async () => {
        console.log("onDelete", id);
        await $studentwall.deleteMessage(id);
        await refresh();
    }
    
    const refresh = async () => {
        const freshMessage = await $studentwall.getMessage(id);
        console.log(freshMessage);
        if (freshMessage.ok){
            vote = freshMessage.ok.vote;
            content = freshMessage.ok.content;
            edited = freshMessage.ok.edited;
        };
    }

    const upVote = async () => {
        console.log("upVote");
        await $studentwall.upVote(id);
        await refresh();
    };

    const downVote = async () => {
        console.log("downVote");
        await $studentwall.downVote(id);
        await refresh();
    };


</script>

<div class = "post" id = "post-{id}">
    <div class="container">
        
        <div class = "author">{handle ? "@"+handle : creator} said:</div>
        
        {#if $wallet}
            {#if (creator != $wallet.principal)}
                <button disabled= {disableTips}  on:click={onTipping(creator)}>
                    <Fa icon={faHandHoldingDollar} /> Tip
                </button>
            {:else}
            <div class="buttons">
                <button on:click={onEdit}>
                    <Fa icon="{faPenToSquare}" />
                </button>
                <button on:click={onDelete}>
                    <Fa icon="{faTrash}" />
                </button>
            </div>
            {/if}
        {/if}

    </div>
    {#if editing }
        <textarea bind:value = {updatedText} placeholder = "Express your vent" />
        <button disabled= {!updatedText} on:click = {sendUpdatedMessage} >
            <Fa icon={faRotateRight} />
        </button>
    {:else}
        <div class = "post-content">
            {content.Text}
        </div>
    {/if}
    <div class= "container">
        {#if (edited)}
            <div>**edited</div>
        {:else}
            <div></div>
        {/if}
        <div class = "post-meta">
            Likes: {vote}
            <button on:click={upVote(id)}>
                <Fa icon={faThumbsUp}/>
            </button>
            <button  on:click={downVote(id)}>
                <Fa icon={faThumbsDown}/>
            </button>
        </div>
    </div>
</div>

<style>
    .container{
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .container button {
        margin-left: 5px;
        opacity: 0.5;
        text-align: right;
    }
    .container .author {
        text-align: left;
        font-weight: bold;
        margin: 10px 0px;
        margin-bottom: 0px;   
        margin-left:0px;     
    }

    .post {
        border: 1px solid #62676d22;
        display: flex;
        flex-direction: column;
        padding: 10px 20px;
        font-weight: lighter;
        background-color: #FFFFF0;
        box-shadow: 0px 0px 20px #1d2025;
        margin-top: 30px;
    }
    
    .post:hover {
        border: 1px solid #62676d99;
    }

    .post-meta {
        display: flex;
        justify-content: space-between;
        padding: 10px 0px;
        margin: 0px;
        font-size: small;
        border-top: 1px solid #dce4ec22;
        padding-bottom: 0px;
        align-self:end;
    }

    .post-content {
        margin: 20px 0px;
        opacity: 0.8;
        padding-right: 15px;
        font-size: xx-large;
    }
</style>