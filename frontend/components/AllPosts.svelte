<script>
    import Post from "./Post.svelte";
    import NewPost from "./NewPost.svelte";
    import {onMount, onDestroy} from "svelte";

    import { useCanister } from "@connect2ic/svelte"

    const [studentwall, { loading }] = useCanister("studentwall")

    let allPosts;
    

    const refresh = async () => {
        console.log("refresh");
        allPosts = await $studentwall.getAllMessagesRanked();
    }
    
    $: {
        if (!$loading && $studentwall) {
            refresh();
        }
    }
    onMount( async () => {
        refresh();
        //allPosts = await $studentwall.getAllMessages();
        console.log("Component mounted");
    });

    onDestroy( () => {
        console.log("Componend destroyed");
    });


    function handleChildEvent() {
        console.log("Evento ricevuto dal modulo figlio");
        refresh();
    }

</script>

<NewPost on:customEvent={handleChildEvent}/>

<div class = "all-posts" >
    {#if !allPosts || $loading}
        <div class = "loader"> Loading...</div>
    {:else}
        {#each allPosts as post (post.id) }
            <Post {...post} />
        {/each}
    {/if}
</div>
<style>
    .loader{
        font-size: x-small;
        padding-top: 20px;
        opacity: 0.6;
    }
</style>