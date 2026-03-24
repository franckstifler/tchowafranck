defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def home(conn, _params) do
    posts = Blog.get_all_posts()
    render(conn, :home, posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug(slug)

    related_posts =
      case Blog.get_related_posts(post, 3) do
        [] -> Blog.get_latest_posts(3)
        posts -> posts
      end

    render(conn, :show, post: post, related_posts: related_posts)
  end

  def create_comment(conn, %{"comment" => %{"post_id" => post_id} = comment_params}) do
    case Blog.create_comment(comment_params) do
      {:ok, _comment} ->
        post = Blog.Repo.get!(Blog.Post, post_id)

        conn
        |> put_flash(:info, "Comment submitted successfully! It will be visible after approval.")
        |> redirect(to: "/posts/#{post.slug}")

      {:error, changeset} ->
        post = Blog.get_post_by_slug(Blog.Repo.get!(Blog.Post, post_id).slug)
        render(conn, :show, post: post, comment_changeset: changeset)
    end
  end

  def tag(conn, %{"tag" => tag}) do
    posts = Blog.get_posts_by_tag(tag)
    render(conn, :home, posts: posts, tag: tag)
  end

  def about(conn, _) do
    render(conn, :about)
  end

  def contact(conn, _) do
    render(conn, :contact)
  end
end
